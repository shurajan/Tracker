//
//  MainTabBarViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.10.2024.
//
import UIKit

final class TrackerViewController: LightStatusBarViewController {
    private var constraints = [NSLayoutConstraint]()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Add tracker"), for: UIControl.State.normal)
        button.accessibilityIdentifier = "plusButton"
        constraints.append(contentsOf: [
            button.widthAnchor.constraint(equalToConstant: 42),
            button.heightAnchor.constraint(equalToConstant: 42),
        ])
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
        constraints.append(contentsOf: [
            picker.widthAnchor.constraint(equalToConstant: 100),
            picker.heightAnchor.constraint(equalToConstant: 34),
        ])
        
        return picker
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()
    
    private lazy var placeHolderView: UIStackView = {
        let imageView = UIImageView(image: UIImage(named: "Dizzy"))
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Создаем UILabel
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        constraints.append(contentsOf: [
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
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
        
        addView(control: datePicker)
        addView(control: plusButton)
        addView(control: placeHolderView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationItem.searchController = searchController
        
        addAndActivateConstraints(from: constraints)
    }
    
}
