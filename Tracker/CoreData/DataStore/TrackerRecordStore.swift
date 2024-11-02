//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Alexander Bralnin on 24.10.2024.
//

import CoreData

enum TrackerRecordStoreError: Error {
    case createTrackerRecordError
}

final class TrackerRecordStore: BasicStore {
    private var trackerStore = TrackerStore()
    
    func manageTrackerRecord(trackerRecord :TrackerRecord) {
        let records = findCoreData(by: trackerRecord.trackerId, and: trackerRecord.date)
        
        if records.isEmpty {
            do {
                guard
                    let tracker = try trackerStore.findCoreData(by: trackerRecord.trackerId)
                else {
                    Log.error(error: TrackerRecordStoreError.createTrackerRecordError, message: "Failed to find tracker with id \(trackerRecord.trackerId)")
                    return
                }
                        
                let trackerRecordCoreData = TrackerRecordCoreData(context: self.managedObjectContext)
                trackerRecordCoreData.tracker_id = trackerRecord.trackerId
                trackerRecordCoreData.date = trackerRecord.date.startOfDay()
                trackerRecordCoreData.tracker = tracker
            } catch {
                Log.error(error: error, message: "Failed to create TrackerRecord for id \(trackerRecord.trackerId)")
                return
            }
    
        } else {
            for record in records {
                managedObjectContext.delete(record)
            }
        }
    }
    
    func count(by id: UUID) -> Int {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker_id == %@", id as CVarArg)
        fetchRequest.resultType = .countResultType
        
        do {
            let count = try managedObjectContext.count(for: fetchRequest)
            return count
        } catch {
            Log.error(error: error)
            return 0
        }
    }
    
    func exist(trackerRecord :TrackerRecord) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrackerRecordCoreData.fetchRequest()
        let searchDate = trackerRecord.date.startOfDay() as NSDate
        let id = trackerRecord.trackerId as CVarArg
        fetchRequest.predicate = NSPredicate(format: "tracker_id == %@ AND date == %@", id as CVarArg, searchDate)
        fetchRequest.resultType = .countResultType
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try managedObjectContext.count(for: fetchRequest)
            return count > 0
        } catch {
            Log.error(error: error)
            return false
        }
    }
    
    private func findCoreData(by id: UUID) -> [TrackerRecordCoreData] {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker_id == %@", id as CVarArg)
        
        do {
            let fetchedRecords = try managedObjectContext.fetch(fetchRequest)
            return fetchedRecords
        } catch {
            Log.error(error: error)
            return []
        }
    }
    
    private func findCoreData(by id: UUID, and date: Date) -> [TrackerRecordCoreData] {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        let dateStart = Calendar.current.startOfDay(for: date) as NSDate
        fetchRequest.predicate = NSPredicate(format: "tracker_id == %@ AND date == %@", id as CVarArg, dateStart)
        
        do {
            let fetchedRecords = try managedObjectContext.fetch(fetchRequest)
            return fetchedRecords
        } catch {
            Log.error(error: error)
            return []
        }
    }
    
}
