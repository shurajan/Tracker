//
//  ScheduleDelegateProtocol.swift
//  Tracker
//
//  Created by Alexander Bralnin on 15.10.2024.
//

protocol ScheduleDelegateProtocol: AnyObject {
    func didSelectDays(_ selectedDays: [WeekDays])
}
