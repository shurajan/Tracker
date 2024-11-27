//
//  StatisticsCoreData.swift
//  Tracker
//
//  Created by Alexander Bralnin on 23.11.2024.
//
import CoreData

protocol StatisticsProtocol {
    func loadData()
    func countBestPeriod() -> Int
    func countPerfectDays() -> Int
    func countCompletedTrackers() -> Int
    func getAverageValue() -> Int
}

struct TrackersByWeekday {
    let weekday: WeekDays
    let trackerIDs: Set<UUID>
}

struct RecordsByDate {
    let date: Date
    let weekday: WeekDays
    let trackerIDs: Set<UUID>
}

struct TrackersByDate {
    let date: Date
    let weekday: WeekDays
    let trackerIDs: Set<UUID>
}

final class StatisticsStore: BasicStore, StatisticsProtocol {
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    private var trackersByWeekday: [TrackersByWeekday]?
    private var habitRecordsByDate: [RecordsByDate]?
    private var allRecordsByDate: [RecordsByDate]?
    private var oneOffByDate: [TrackersByDate]?
    
    
    func loadData() {
        self.trackersByWeekday = getHabitsGroupedByWeekday()
        self.habitRecordsByDate = getRecordsGroupedByDate(filterByHabits: true)
        self.allRecordsByDate = getRecordsGroupedByDate(filterByHabits: false)
        self.oneOffByDate = getOneOffGroupedByDate()
    }
    
    func countBestPeriod() -> Int {
        guard let allRecordsByDate,
              let oneOffByDate,
              let trackersByWeekday
        else { return 0 }
        
        let trackersByWeekdayDict: [WeekDays: Set<UUID>] = trackersByWeekday.reduce(into: [:]) { result, entry in
            result[entry.weekday] = entry.trackerIDs
        }
        
        let oneOffDict: [Date: Set<UUID>] = oneOffByDate.reduce(into: [:]) { result, entry in
            result[entry.date] = entry.trackerIDs
        }
        let sortedRecords = allRecordsByDate.sorted { $0.date < $1.date }
        
        var bestPeriod = 0
        var currentStreak = 0
        var previousDate: Date? = nil
        
        for record in sortedRecords {
            let completedTrackerIDs = record.trackerIDs
            
            let weekday = record.weekday
            let expectedHabitTrackerIDs = trackersByWeekdayDict[weekday] ?? []
            let expectedOneOffTrackerIDs = oneOffDict[record.date] ?? []
            
            let allExpectedTrackerIDs = expectedHabitTrackerIDs.union(expectedOneOffTrackerIDs)
            if completedTrackerIDs == allExpectedTrackerIDs {
                if let prevDate = previousDate {
                    let daysDifference = Calendar.current.dateComponents([.day], from: prevDate, to: record.date).day ?? 0
                    if daysDifference == 1 {
                        currentStreak += 1
                    } else {
                        bestPeriod = max(bestPeriod, currentStreak)
                        currentStreak = 1
                    }
                } else {
                    currentStreak = 1
                }
                previousDate = record.date
            } else {
                bestPeriod = max(bestPeriod, currentStreak)
                currentStreak = 0
                previousDate = nil
            }
        }

        bestPeriod = max(bestPeriod, currentStreak)
        
        return bestPeriod
    }
    
    func countPerfectDays() -> Int {
        guard let trackersByWeekday,
              let habitRecordsByDate
        else {return 0}
        
        let trackersDict: [WeekDays: Set<UUID>] = trackersByWeekday.reduce(into: [:]) { result, entry in
            result[entry.weekday] = entry.trackerIDs
        }
        
        var perfectDaysCount = 0
        
        for record in habitRecordsByDate {
            guard let expectedTrackerIDs = trackersDict[record.weekday] else { continue }
            let completedTrackerIDs = record.trackerIDs
            
            if completedTrackerIDs == expectedTrackerIDs {
                perfectDaysCount += 1
            }
        }
        
        return perfectDaysCount
    }
    
    
    func countCompletedTrackers() -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.schedule != 0 AND tracker.schedule != nil")
        
        do {
            let count = try self.managedObjectContext.count(for: fetchRequest)
            return count
        } catch {
            Log.error(error: error, message: "Can not count completed trackers")
            return 0
        }
    }
    
    func getAverageValue() -> Int {
        guard let habitRecordsByDate else {return 0}
                
        guard !habitRecordsByDate.isEmpty else { return 0 }
        
        let totalCompletedTrackers = habitRecordsByDate.reduce(0) { result, record in
            result + record.trackerIDs.count
        }
        
        let average = Double(totalCompletedTrackers) / Double(habitRecordsByDate.count)
        
        return Int(round(average))
    }
    

    
    private func getHabitsGroupedByWeekday() -> [TrackersByWeekday] {
        let context = self.managedObjectContext
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = FilterPredicateFactory.makePredicate(for: .scheduled)
        
        do {
            let trackers = try context.fetch(fetchRequest)
            
            var groupedTrackers: [WeekDays: Set<UUID>] = [:]
            WeekDays.allDays.forEach { groupedTrackers[$0] = [] }
            
            for tracker in trackers {
                guard let id = tracker.id else { continue }
                
                let schedule = tracker.schedule
                let trackerDays = WeekDays(rawValue: schedule)
                
                for day in trackerDays {
                    groupedTrackers[day, default: []].insert(id)
                }
            }
            
            return groupedTrackers.compactMap { key, value in
                guard !value.isEmpty else { return nil }
                return TrackersByWeekday(weekday: key, trackerIDs: value)
            }
        } catch {
            Log.error(error: error, message: "Can not extract trackers by weekday")
            return []
        }
    }
    
    private func getOneOffGroupedByDate() -> [TrackersByDate] {
        let context = self.managedObjectContext
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        fetchRequest.predicate = FilterPredicateFactory.makePredicate(for: .oneOff)
        
        do {
            let trackers = try context.fetch(fetchRequest)
            guard !trackers.isEmpty else { return [] }
            
            var groupedTrackers: [Date: Set<UUID>] = [:]
            let calendar = Calendar.current
            
            for tracker in trackers {
                guard let date = tracker.date, let trackerID = tracker.id else { continue }
                
                let startOfDay = calendar.startOfDay(for: date)
                groupedTrackers[startOfDay, default: []].insert(trackerID)
            }
            
            return groupedTrackers.map { key, value in
                let weekdayIndex = calendar.component(.weekday, from: key)
                let weekday = WeekDays.fromGregorianStyle(weekdayIndex) ?? .Sunday
                return TrackersByDate(date: key, weekday: weekday, trackerIDs: value)
            }.sorted { $0.date < $1.date }
        } catch {
            Log.error(error: error, message: "Failed to fetch trackers grouped by date")
            return []
        }
    }
    
    private func getRecordsGroupedByDate(filterByHabits: Bool = true) -> [RecordsByDate] {
        let context = self.managedObjectContext
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        if filterByHabits {
            fetchRequest.predicate = NSPredicate(format: "tracker.schedule != 0 AND tracker.schedule != nil")
        }
        
        do {
            let records = try context.fetch(fetchRequest)
            guard !records.isEmpty else { return [] }
            
            var groupedRecords: [Date: Set<UUID>] = [:]
            let calendar = Calendar.current
            
            for record in records {
                guard let date = record.date, let trackerID = record.tracker_id else { continue }
                
                let startOfDay = calendar.startOfDay(for: date)
                groupedRecords[startOfDay, default: []].insert(trackerID)
            }
            
            return groupedRecords.map { key, value in
                let weekdayIndex = calendar.component(.weekday, from: key)
                let weekday = WeekDays.fromGregorianStyle(weekdayIndex) ?? .Sunday
                return RecordsByDate(date: key, weekday: weekday, trackerIDs: value)
            }.sorted { $0.date < $1.date }
        } catch {
            Log.error(error: error, message: "Can not extract records by date")
            return []
        }
    }
}
