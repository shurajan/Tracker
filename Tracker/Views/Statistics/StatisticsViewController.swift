//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 04.10.2024.
//
import UIKit

final class StatisticsViewController: BasicViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var statisticsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var placeHolderView: PlaceHolderView = {
        let view = PlaceHolderView()
        view.setText(text: LocalizedStrings.Statistics.placeholderText)
        view.setImage(name: "Nothing")
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: StatisticsViewModel
    
    init(viewModel: StatisticsViewModel = StatisticsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.Dynamic.white
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStatistics()
    }
    
    private func setupView() {
        self.title = LocalizedStrings.Statistics.title
        definesPresentationContext = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: Fonts.titleLargeFont
        ]
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(placeHolderView)
        view.addSubview(scrollView)
        scrollView.addSubview(statisticsStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            statisticsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            statisticsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            statisticsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            statisticsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            statisticsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            placeHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Insets.leading),
            placeHolderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Insets.trailing),
        ])
    }
    
    private func loadStatistics() {
        statisticsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let dataItems = viewModel.getStatisticsItems()
        
        self.placeHolderView.isHidden = !dataItems.isEmpty
        self.scrollView.isHidden = dataItems.isEmpty
        
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
    }
}
