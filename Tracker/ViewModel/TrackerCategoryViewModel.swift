//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Alexander Bralnin on 08.11.2024.
//


final class TrackerCategoryViewModel {
    
    private(set) var trackerCategories: [TrackerCategory] = [] {
        didSet {
            trackerCategoriesBinding?(trackerCategories)
        }
    }
    private let trackerCategoryStore = TrackerCategoryStore()
    
    var trackerCategoriesBinding: Binding<[TrackerCategory]>?
    
    init() throws {
        trackerCategoryStore.delegate = self
        fetchTrackerCategories()
    }
        
    func addTrackerCategory(category: String) {
        try? trackerCategoryStore.addTrackerCategory(category: category)
    }
    
    private func fetchTrackerCategories() {
        do {
            self.trackerCategories = try trackerCategoryStore.fetchTrackerCategories()
        } catch {
            print("failed to get categories from store")
        }
    }
}

extension TrackerCategoryViewModel: StoreDelegate {
    func storeDidUpdate() {
        fetchTrackerCategories()
    }
}
