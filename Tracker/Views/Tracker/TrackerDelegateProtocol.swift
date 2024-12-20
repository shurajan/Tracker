//
//  ScheduleDelegateProtocol.swift
//  Tracker
//
//  Created by Alexander Bralnin on 15.10.2024.
//

import Foundation

protocol TrackerDelegateProtocol: AnyObject {
    func didSelectDays(_ selectedDays: WeekDays)
    func didSelectEmoji(_ indexPath: IndexPath)
    func didSelectColor(_ indexPath: IndexPath)
    func didSelectCategory(category: String)
}
