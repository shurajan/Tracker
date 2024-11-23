//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Alexander Bralnin on 23.11.2024.
//

import Foundation

struct StatisticsItem {
    let value: String
    let description: String
}

final class StatisticsViewModel {
    private let statisticsStore: StatisticsProtocol
    
    init(statisticsStore: StatisticsProtocol = StatisticsStore()) {
        self.statisticsStore = statisticsStore
    }
    
    func getStatisticsItems() -> [StatisticsItem] {
        let items = [
            (value: statisticsStore.countBestPeriod(), description: LocalizedStrings.Statistics.bestPeriod),
            (value: statisticsStore.countPerfectDays(), description: LocalizedStrings.Statistics.perfectDays),
            (value: statisticsStore.countCompletedTrackers(), description: LocalizedStrings.Statistics.trackersCompleted),
            (value: statisticsStore.getAverageValue(), description: LocalizedStrings.Statistics.averageValue)
        ]
        
        return items
            .filter { $0.value > 0 }
            .map { StatisticsItem(value: "\($0.value)", description: $0.description) }
    }
}