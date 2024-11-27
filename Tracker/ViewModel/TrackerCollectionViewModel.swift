//
//  TrackerCollectionViewModel.swift
//  Tracker
//
//  Created by Alexander Bralnin on 20.11.2024.
//

import Foundation

protocol TrackerCollectionViewModelProtocol {
    func numberOfSections() -> Int
    func titleForSection(_ section: Int) -> String?
    func numberOfRowsInSection(_ section: Int) -> Int
    func item(at indexPath: IndexPath) -> Tracker?
    func categoryForItem(at indexPath: IndexPath) -> String?
}

final class TrackerCollectionViewModel: TrackerCollectionViewModelProtocol {
    private var viewModel: TrackersViewModelProtocol?
    
    init(viewModel: TrackersViewModelProtocol?) {
        self.viewModel = viewModel
    }
    
    func numberOfSections() -> Int {
        return viewModel?.visibleCategories.count ?? 0
    }
    
    func titleForSection(_ section: Int) -> String? {
        return viewModel?.visibleCategories[safe: section]?.title
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return viewModel?.visibleCategories[safe: section]?.trackers?.count ?? 0
    }
    
    func item(at indexPath: IndexPath) -> Tracker? {
        let section = indexPath.section
        let row = indexPath.row
        
        return viewModel?.visibleCategories[safe: section]?.trackers?[safe: row]
    }
    
    func categoryForItem(at indexPath: IndexPath) -> String? {
        let section = indexPath.section
        let row = indexPath.row
        
        if let id = viewModel?.visibleCategories[safe: section]?.trackers?[safe: row]?.id {
            return viewModel?.category(for: id)
        }
        return nil
    }
}
