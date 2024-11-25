//
//  StatisticsStoreTest.swift
//  Tracker
//
//  Created by Alexander Bralnin on 25.11.2024.
//

import XCTest
@testable import Tracker

final class StatisticsStoreTest: XCTestCase {
    private var trackerStore = TrackerStore()
    private var trackerRecordStore = TrackerRecordStore()
    private var statisticsStore = StatisticsStore()
    
    private let id1 = UUID()
    private let id2 = UUID()
    
    private let date = Date().startOfDay()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        prepareTestData()
    }
    
    override func tearDownWithError() throws {
        trackerStore.deleteAll()
        try super.tearDownWithError()
    }
    
    private func prepareTestData() {
        trackerStore.deleteAll()
        let category = "Test Category"
        
        let tracker1 = Tracker(
            id: id1,
            name: "Tracker 1",
            color: .selection1,
            emoji: .angel,
            date: date,
            schedule: nil,
            isPinned: true,
            isComplete: false
        )
        
        let tracker2 = Tracker(
            id: id2,
            name: "Tracker 2",
            color: .selection2,
            emoji: .angry,
            date: date,
            schedule: WeekDays.Daily,
            isPinned: false,
            isComplete: false
        )
        
        trackerStore.addTracker(tracker: tracker1, category: category)
        trackerStore.addTracker(tracker: tracker2, category: category)
        
        let trackerRecord2 = TrackerRecord(trackerId: id2, date: date)
        
        trackerRecordStore.manageTrackerRecord(trackerRecord: trackerRecord2)
        statisticsStore.loadData()
    }
    
    func testCountBestPeriod() {
        var bestPeriod = statisticsStore.countBestPeriod()
        XCTAssertEqual(bestPeriod, 0, "Best period should be 0")
        
        let trackerRecord1 = TrackerRecord(trackerId: id1, date: date)
        trackerRecordStore.manageTrackerRecord(trackerRecord: trackerRecord1)
        statisticsStore.loadData()
        bestPeriod = statisticsStore.countBestPeriod()
        XCTAssertEqual(bestPeriod, 1, "Best period should be 1 after change")
    }
    
    func testCountPerfectDays() {
        let perfectDays = statisticsStore.countPerfectDays()
        XCTAssertEqual(perfectDays, 1, "Perfect days should be 1")
    }
    
    func testCountCompletedTrackers() {
        let completedTrackers = statisticsStore.countCompletedTrackers()
        XCTAssertEqual(completedTrackers, 1, "Completed trackers should be 1")
    }
    
    func testGetAverageValue() {
        let averageValue = statisticsStore.getAverageValue()
        XCTAssertEqual(averageValue, 1, "Average value should be 1")
    }
}
