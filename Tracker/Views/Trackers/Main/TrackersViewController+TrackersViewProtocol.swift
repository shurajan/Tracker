//
//  TrackersViewController+TrackersViewProtocol.swift
//  Tracker
//
//  Created by Alexander Bralnin on 18.11.2024.
//
import UIKit

protocol TrackersViewProtocol: AnyObject {
    func showNewHabitViewController()
    func showIrregularEventController()
}


extension TrackersViewController: TrackersViewProtocol {
    func showNewHabitViewController() {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.selectedDate = selectedDate
        newTrackerViewController.eventType = .habit
        newTrackerViewController.delegate = viewModel
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: true, completion: nil)
    }
    
    func showIrregularEventController() {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.selectedDate = selectedDate
        newTrackerViewController.eventType = .one_off
        newTrackerViewController.delegate = viewModel
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: true, completion: nil)
    }
    
}
