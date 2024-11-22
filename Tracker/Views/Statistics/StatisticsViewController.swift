//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.10.2024.
//

import UIKit

final class StatisticsViewController: BasicViewController {
    private let scrollView = UIScrollView()
    private let statisticsStackView = UIStackView()
    
    private let dataItems: [(value: String, description: String)] = [
        ("6", LocalizedStrings.Statistics.bestPeriod),
        ("2", LocalizedStrings.Statistics.perfectDays),
        ("5", LocalizedStrings.Statistics.trackersCompleted),
        ("4", LocalizedStrings.Statistics.averageValue)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.Dynamic.white
        setupView()
    }
    
    private func setupView() {
        self.title = LocalizedStrings.Statistics.title
        definesPresentationContext = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: Fonts.titleLargeFont
        ]
        navigationItem.largeTitleDisplayMode = .always
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        statisticsStackView.axis = .vertical
        statisticsStackView.spacing = 12
        statisticsStackView.alignment = .fill
        statisticsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(statisticsStackView)
        
        for item in dataItems {
            let itemView = StatisticsItemView(value: item.value, description: item.description)
            itemView.borderWidth = 1.0
            itemView.cornerRadius = Constants.radius
            itemView.gradientColors = [
                UIColor(hex: "#007BFA"),
                UIColor(hex: "#46E69D"),
                UIColor(hex: "#FD4C49")
            ]
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.heightAnchor.constraint(equalToConstant: 90).isActive = true
            statisticsStackView.addArrangedSubview(itemView)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            statisticsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            statisticsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            statisticsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            statisticsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            statisticsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}
