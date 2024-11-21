//
//  Filters.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.11.2024.
//

import Foundation

protocol FilterDelegateProtocol {
    var currentFilter: Filters { get }
    func didSelectFilter(filter: Filters)
}

enum Filters: String, CaseIterable {
    case allTrackers = "filters.all_trackers"
    case todayTrackers = "filters.today_trackers"
    case completed = "filters.completed"
    case notCompleted = "filters.not_completed"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    func makePredicate() -> (Tracker) -> Bool {
        switch self {
        case .allTrackers:
            return { _ in true }
            
        case .todayTrackers:
            return { _ in true }
                        
        case .completed:
            return { tracker in tracker.isComplete }
            
        case .notCompleted:
            return { tracker in !tracker.isComplete } 
        }
    }
}



