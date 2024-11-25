//
//  MockFilterDelegate.swift
//  Tracker
//
//  Created by Alexander Bralnin on 25.11.2024.
//

import Foundation
@testable import Tracker

final class MockFilterDelegate: FilterDelegateProtocol {
    var currentFilter: Filters = .allTrackers
    
    func didSelectFilter(filter: Filters) {
        
    }
    
    
}
