//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Alexander Bralnin on 09.10.2024.
//
import Foundation

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]?
    
    init(title: String, trackers: [Tracker]? = nil) {
        self.title = title
        self.trackers = trackers
    }
    
}
