//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Alexander Bralnin on 09.10.2024.
//
import Foundation

struct TrackerCategory {
    let id: UUID
    let title: String
    let trackers: [Tracker]
}
