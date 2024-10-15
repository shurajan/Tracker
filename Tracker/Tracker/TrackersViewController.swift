//
//  MainTabBarViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.10.2024.
//
import UIKit

final class TrackersViewController: LightStatusBarViewController {
    private var categories = [TrackerCategory]()
    private var completedTrackers = [TrackerRecord]()
    
    //MARK: - UI components
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Add tracker"), for: UIControl.State.normal)
        button.accessibilityIdentifier = "plusButton"
        button.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = UIColor.ysBackground
        picker.layer.cornerRadius = 8
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        picker.locale = Locale(identifier: "ru_RU")
        picker.accessibilityIdentifier = "datePicker"
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()
    
    private lazy var dizzyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Dizzy"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeHolderView: UIStackView = {
        // Создаем UILabel
        let stackView = UIStackView(arrangedSubviews: [dizzyImageView, questionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        //TODO: - added in sprint_14 as a stub
        let category = TrackerCategory(id: UUID(), title: "Базовая", trackers: [])
        addCategory(category: category)
    }
    
    //MARK: - View Layout methods
    private func setupLayout(){
        self.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = UIColor.ysWhite
        
        view.addSubview(datePicker)
        view.addSubview(plusButton)
        view.addSubview(placeHolderView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationItem.searchController = searchController
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            dizzyImageView.widthAnchor.constraint(equalToConstant: 80),
            dizzyImageView.heightAnchor.constraint(equalToConstant: 80),
            placeHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeHolderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    //MARK: - Private Methods
    private func addCategory(category: TrackerCategory){
        self.categories = categories + [category]
    }
    
    private func filterTrackers(by date: Date, trackers: [Tracker]) -> [Tracker] {
        var calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        
        return trackers.filter { tracker in
            switch tracker.schedule {
            case .weekly(let days):
                if let weekDay = WeekDays.fromGregorianStyle(dayOfWeek) {
                    return days.contains(weekDay)
                }
                return false
            case .specificDate(let specificDate):
                return calendar.isDate(specificDate, inSameDayAs: date)
            }
        }
    }
    
    //MARK: - IB Outlet
    @IBAction
    private func plusButtonTapped(_ sender: UIButton) {
        let trackerCreationViewController = TrackerTypeSelectorViewController()
        trackerCreationViewController.delegate = self
        trackerCreationViewController.modalPresentationStyle = .pageSheet
        present(trackerCreationViewController, animated: false, completion: nil)
    }
    
    @IBAction
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
        
        let selectedTrackers = filterTrackers(by: selectedDate, trackers: categories[0].trackers)
        print(selectedTrackers)
    }
}

extension TrackersViewController: TrackersViewControllerProtocol {
    func didCreateNewTracker(tracker: Tracker) {
        guard let category = categories[safe: 0] else {return}
        let trackers = category.trackers + [tracker]
        categories.remove(at: 0)
        categories.append(TrackerCategory(id: category.id, title: category.title, trackers: trackers))
    }
    
    func showNewHabitViewController() {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.eventType = .habit
        newTrackerViewController.delegate = self
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: false, completion: nil)
    }
    
    func showIrregularEventController() {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.eventType = .one_off
        newTrackerViewController.delegate = self
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: false, completion: nil)
    }
}
