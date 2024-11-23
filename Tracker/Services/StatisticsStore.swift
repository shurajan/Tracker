//
//  StatisticsCoreData.swift
//  Tracker
//
//  Created by Alexander Bralnin on 23.11.2024.
//
import CoreData

protocol StatisticsProtocol {
    func countBestPeriod() -> Int
    func countPerfectDays() -> Int
    func countCompletedTrackers() -> Int
    func getAverageValue() -> Int
}

final class StatisticsStore: BasicStore, StatisticsProtocol {
    private var trackerRecordStore: TrackerRecordStore?
    
    init(trackerRecordStore: TrackerRecordStore = TrackerRecordStore()) {
        super.init()
        self.trackerRecordStore = trackerRecordStore
    }
    
    func countBestPeriod() -> Int {
        return 1111
    }
    
    func countPerfectDays() -> Int {
        return 2222
    }
    
    func countCompletedTrackers() -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.schedule != 0 AND tracker.schedule != nil")
        
        do {
            let count = try self.managedObjectContext.count(for: fetchRequest)
            return count
        } catch {
            Log.error(error: error, message: "Can not count competed trackers")
            return 0
        }
    }
    
    func getAverageValue() -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.schedule != 0 AND tracker.schedule != nil")
        fetchRequest.relationshipKeyPathsForPrefetching = ["tracker"]
        
        do {
            let records = try self.managedObjectContext.fetch(fetchRequest)
            
            var recordsByDate: [Date: Int] = [:]
            let calendar = Calendar.current
            for record in records {
                guard let date = record.date else { continue }
                let startOfDay = calendar.startOfDay(for: date)
                recordsByDate[startOfDay, default: 0] += 1
            }
            
            let totalHabits = recordsByDate.values.reduce(0, +)
            let totalDays = recordsByDate.count
            let average = totalDays > 0 ? Double(totalHabits) / Double(totalDays) : 0.0
            
            return Int(round(average))
            
        } catch {
            Log.error(error: error, message: "can not count average")
            return 0
        }
    }
    
    
}
