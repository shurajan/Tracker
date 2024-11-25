//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Alexander Bralnin on 24.11.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerScreenshotTests: XCTestCase {
    private var trackerStore = TrackerStore()
    private var trackerRecordStore = TrackerRecordStore()
    
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
        
        let date = Date().startOfDay()
        
        let id1 = UUID()
        let id2 = UUID()
        
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
    }
    
    func testTrackersViewController() throws {
        let vc = TrackersViewController()
        
        vc.overrideUserInterfaceStyle = .light
        assertSnapshot(of: vc, as: .image, named: "LightMode")
        
        vc.overrideUserInterfaceStyle = .dark
        assertSnapshot(of: vc, as: .image, named: "DarkMode")
    }
    
    func testFilterViewController() throws {
        let delegate = MockFilterDelegate()
        let vc = FiltersViewController(delegate: delegate)
        
        vc.overrideUserInterfaceStyle = .light
        assertSnapshot(of: vc, as: .image, named: "LightMode")
        
        vc.overrideUserInterfaceStyle = .dark
        assertSnapshot(of: vc, as: .image, named: "DarkMode")
    }
    
    func testTrackerViewController() throws {
        let vc = TrackerViewController()
        
        vc.overrideUserInterfaceStyle = .light
        assertSnapshot(of: vc, as: .image, named: "LightMode")
        
        vc.overrideUserInterfaceStyle = .dark
        assertSnapshot(of: vc, as: .image, named: "DarkMode")
    }
    
    func testNewCategoryViewController() throws {
        let vc = NewCategoryViewController()
        
        vc.overrideUserInterfaceStyle = .light
        assertSnapshot(of: vc, as: .image, named: "LightMode")
        
        vc.overrideUserInterfaceStyle = .dark
        assertSnapshot(of: vc, as: .image, named: "DarkMode")
    }
    
    func testScheduleViewController() throws {
        let vc = ScheduleViewController()
        
        vc.overrideUserInterfaceStyle = .light
        assertSnapshot(of: vc, as: .image, named: "LightMode")
        
        vc.overrideUserInterfaceStyle = .dark
        assertSnapshot(of: vc, as: .image, named: "DarkMode")
    }
    
    func testCategoriesViewController() throws {
        let delegate = MockTrackerDelegate()
        let vc = CategoriesViewController(delegate: delegate)
        
        vc.overrideUserInterfaceStyle = .light
        assertSnapshot(of: vc, as: .image, named: "LightMode")
        
        vc.overrideUserInterfaceStyle = .dark
        assertSnapshot(of: vc, as: .image, named: "DarkMode")
    }
    
    func testContentViewController() throws {
        
        let vc = ContentViewController()
        
        vc.overrideUserInterfaceStyle = .light
        assertSnapshot(of: vc, as: .image, named: "LightMode")
        
        vc.overrideUserInterfaceStyle = .dark
        assertSnapshot(of: vc, as: .image, named: "DarkMode")
    }
    
    func testPageViewController() throws {
        
        let vc = PageViewController()
        
        vc.overrideUserInterfaceStyle = .light
        assertSnapshot(of: vc, as: .image, named: "LightMode")
        
        vc.overrideUserInterfaceStyle = .dark
        assertSnapshot(of: vc, as: .image, named: "DarkMode")
    }
    
    func testPlaceHolderView() {
        let pv = PlaceHolderView()
        pv.setText(text: "Test placeholder view")
        pv.overrideUserInterfaceStyle = .light
        assertSnapshot(of: pv, as: .image, named: "LightMode")
        pv.overrideUserInterfaceStyle = .dark
        assertSnapshot(of: pv, as: .image, named: "DarkMode")
    }
}
