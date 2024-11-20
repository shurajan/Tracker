//
//  LocalizedStrings.swift
//  Tracker
//
//  Created by Alexander Bralnin on 14.11.2024.
//
import Foundation

enum LocalizedStrings {
    enum Onboarding {
        static let firstTitle = NSLocalizedString("onboarding.first.title", comment: "Title for the first onboarding screen")
        static let secondTitle = NSLocalizedString("onboarding.second.title", comment: "Title for the second onboarding screen")
        static let buttonText = NSLocalizedString("onboarding.button.text", comment: "Text for the onboarding button")
    }
    
    enum Trackers {
        static let title = NSLocalizedString("trackers.title", comment: "Title for the trackers screen")
        static let placeholderText = NSLocalizedString("trackers.placeholder.text", comment: "Text for the placeholder")
        static let searchPlaceHolderText = NSLocalizedString("tracker.search_placeholder.text", comment: "Text for the search placeholder")
        static let filterButtonText = NSLocalizedString("trackers.filter_button.text", comment: "Text for the filter button")
        
        enum ContextMenu {
            static let pin = NSLocalizedString("trackers.context_menu.pin", comment: "Pin the tracker")
            static let unpin = NSLocalizedString("trackers.context_menu.unpin", comment: "Unpin the tracker")
            static let edit = NSLocalizedString("trackers.context_menu.edit", comment: "Edit the tracker")
            static let delete = NSLocalizedString("trackers.context_menu.delete", comment: "Delete the tracker")
        }
        
        enum DeleteAlert {
            static let title = NSLocalizedString("delete.alert.title", comment: "Title for the delete tracker alert")
            static let actionDelete = NSLocalizedString("delete.alert.action.delete", comment: "Delete action button title")
            static let actionCancel = NSLocalizedString("delete.alert.action.cancel", comment: "Cancel action button title")
        }
    }
    
    enum TrackerCell {
        static func formatDaysText(days: Int) -> String {
            return String.localizedStringWithFormat(
                NSLocalizedString("numberOfDays", comment: "Number of days"),
                days
            )
        }
    }
    
    enum Schedule {
        static let title = NSLocalizedString("schedule.title", comment: "Title for the schedule view")
        static let buttonText = NSLocalizedString("schedule.button.text", comment: "Text for the done button in the schedule view")
    }
    
    enum TrackerCreation {
        static let title = NSLocalizedString("tracker_creation.title", comment: "Title for tracker creation view")
        static let habitButton = NSLocalizedString("tracker_creation.button.habit", comment: "Text for the habit creation button")
        static let irregularEventButton = NSLocalizedString("tracker_creation.button.irregular_event", comment: "Text for the irregular event creation button")
    }
    
    enum Tracker {
        static let habitTitle = NSLocalizedString("tracker.event_type.habit", comment: "Title for a new habit tracker")
        static let oneOffTitle = NSLocalizedString("tracker.event_type.one_off", comment: "Title for an irregular event tracker")
        static let habitUpdateTitle = NSLocalizedString("tracker.event_type.update_habit", comment: "Title for a new habit update tracker")
        static let oneOffUpdateTitle = NSLocalizedString("tracker.event_type.update_one_off", comment: "Title for a new habit update tracker")
        static let placeholderName = NSLocalizedString("tracker.placeholder.name", comment: "Placeholder for tracker name input field")
        static let cancelButton = NSLocalizedString("tracker.button.cancel", comment: "Cancel button text")
        static let createButton = NSLocalizedString("tracker.button.create", comment: "Create button text")
        static let saveButton = NSLocalizedString("tracker.button.save", comment: "Save button text")
        static let categoryTitle = NSLocalizedString("tracker.title.category", comment: "Title for category cell")
        static let scheduleTitle = NSLocalizedString("tracker.title.schedule", comment: "Title for schedule cell")
        static let colorText = NSLocalizedString("tracker.color.text", comment: "Title for color selection collection view")
    }
    
    enum Categories {
        static let title = NSLocalizedString("categories.title", comment: "Title for the categories view")
        static let addButton = NSLocalizedString("categories.button.add", comment: "Add category button text")
        static let placeholderText = NSLocalizedString("categories.placeholder.text", comment: "Placeholder text when no categories are available")
    }
    
    enum NewCategory {
        static let title = NSLocalizedString("new_category.title", comment: "Title for new category view")
        static let placeholder = NSLocalizedString("new_category.placeholder", comment: "Placeholder for category name input field")
        static let doneButton = NSLocalizedString("new_category.button.done", comment: "Text for done button")
    }
    
    enum WeekDays {
        static let monday = NSLocalizedString("weekdays.monday", comment: "Monday")
        static let tuesday = NSLocalizedString("weekdays.tuesday", comment: "Tuesday")
        static let wednesday = NSLocalizedString("weekdays.wednesday", comment: "Wednesday")
        static let thursday = NSLocalizedString("weekdays.thursday", comment: "Thursday")
        static let friday = NSLocalizedString("weekdays.friday", comment: "Friday")
        static let saturday = NSLocalizedString("weekdays.saturday", comment: "Saturday")
        static let sunday = NSLocalizedString("weekdays.sunday", comment: "Sunday")
        
        static let shortMonday = NSLocalizedString("weekdays.short.monday", comment: "Short form for Monday")
        static let shortTuesday = NSLocalizedString("weekdays.short.tuesday", comment: "Short form for Tuesday")
        static let shortWednesday = NSLocalizedString("weekdays.short.wednesday", comment: "Short form for Wednesday")
        static let shortThursday = NSLocalizedString("weekdays.short.thursday", comment: "Short form for Thursday")
        static let shortFriday = NSLocalizedString("weekdays.short.friday", comment: "Short form for Friday")
        static let shortSaturday = NSLocalizedString("weekdays.short.saturday", comment: "Short form for Saturday")
        static let shortSunday = NSLocalizedString("weekdays.short.sunday", comment: "Short form for Sunday")
        static let allDays = NSLocalizedString("weekdays.short.all", comment: "Short form for All")
    }
}
