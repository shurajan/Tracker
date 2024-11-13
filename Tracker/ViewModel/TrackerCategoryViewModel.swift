//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Alexander Bralnin on 08.11.2024.
//


final class TrackerCategoryViewModel {
    var trackerCategoriesBinding: Binding<[TrackerCategory]>?
    
    private(set) var trackerCategories: [TrackerCategory] = [] {
        didSet {
            trackerCategoriesBinding?(trackerCategories)
        }
    }
    
    private let trackerCategoryStore = TrackerCategoryStore()

    init() throws {
        trackerCategoryStore.delegate = self
    }
        
    func addTrackerCategory(category: String) {
        do {
            try trackerCategoryStore.addTrackerCategory(category: category)
        } catch {
            Log.error(error: error, message: "failed to store category")
        }
    }
    
    func fetchTrackerCategories() {
        do {
            self.trackerCategories = try trackerCategoryStore.fetchTrackerCategories()
        } catch {
            Log.error(error: error, message: "failed to get categories from store")
        }
    }
}

extension TrackerCategoryViewModel: StoreDelegate {
    func storeDidUpdate() {
        fetchTrackerCategories()
    }
}
