//
//  AnalyticalConstants.swift
//  Tracker
//
//  Created by Alexander Bralnin on 25.11.2024.
//

enum AnalyticsEvent: String {
    case open   = "open"
    case close  = "close"
    case click  = "click"
}

enum AnalyticsEventData {
    enum MainScreen {
        static let name = "Main"
        static let clickAddTracker = ["screen": "Main", "item": "add_tracker"]
        static let clickFilter = ["screen": "Main", "item": "filter"]
        static let clickEdit = ["screen": "Main", "item": "edit"]
        static let clickDelete = ["screen": "Main", "item": "delete"]
        static let clickTracker = ["screen": "Main", "item": "track"]
    }
    
    enum TrackersTypeScreen {
        static let name = "TrackersType"
        static let clickAddTracker = ["screen": "TrackersType", "item": "add_tracker"]
        static let clickAddIrregularEvent = ["screen": "TrackersType", "item": "add_irregularEvent"]
    }
    
    enum NewTrackerScreen {
        static let name = "NewTracker"
        static let clickSave = ["screen": "NewTracker", "item": "save"]
        static let clickCancel = ["screen": "NewTracker", "item": "cancel"]
    }
    
    enum FiltersScreen {
        static let name = "Filters"
        static let selectFilter = ["screen": "Filters", "item": "select_filter"]
    }
    
    enum NewCategory {
        static let name = "NewCategory"
        static let clickCreate = ["screen": "NewCategory", "item": "create"]
    }
}
