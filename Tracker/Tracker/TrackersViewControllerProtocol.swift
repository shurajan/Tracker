//
//  TrackerViewControllerProtocol.swift
//  Tracker
//
//  Created by Alexander Bralnin on 14.10.2024.
//

protocol TrackersViewControllerProtocol {
    func showNewHabitViewController()
    func showIrregularEventController()
    func didCreateNewTracker(tracker: Tracker)
}
