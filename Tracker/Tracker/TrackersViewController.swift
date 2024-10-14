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
        drawSelf()
    }
    
    //MARK: - View Layout methods
    private func drawSelf(){
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
    func addCategory(category: TrackerCategory){
        self.categories = categories + [category]
    }
    
    //MARK: - IB Outlet
    @IBAction
    private func plusButtonTapped(_ sender: UIButton) {
        let trackerCreationViewController = TrackerCreationViewController()
        trackerCreationViewController.delegate = self
        trackerCreationViewController.modalPresentationStyle = .pageSheet
        present(trackerCreationViewController, animated: false, completion: nil)
    }
}

extension TrackersViewController: TrackersViewControllerProtocol {
    func showNewHabbitViewController() {
        let newHabitViewController = NewHabitViewController()
        newHabitViewController.delegate = self
        newHabitViewController.modalPresentationStyle = .pageSheet
        present(newHabitViewController, animated: false, completion: nil)
    }
    
    func showIrregularEventController() {
    }
}
