//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Alexander Bralnin on 11.10.2024.
//

import UIKit

final class TrackerTypeSelectorViewController: BasicViewController {
    var delegate: TrackersViewProtocol?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedStrings.TrackerCreation.title
        label.font = Fonts.titleMediumFont
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedStrings.TrackerCreation.habitButton, for: .normal)
        button.titleLabel?.font = Fonts.titleMediumFont
        button.setTitleColor(AppColors.Dynamic.white, for: .normal)
        button.backgroundColor = AppColors.Dynamic.black
        button.layer.cornerRadius = Constants.radius
        button.addTarget(self, action: #selector(habitButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizedStrings.TrackerCreation.irregularEventButton, for: .normal)
        button.titleLabel?.font = Fonts.titleMediumFont
        button.setTitleColor(AppColors.Dynamic.white, for: .normal)
        button.backgroundColor = AppColors.Dynamic.black
        button.layer.cornerRadius = Constants.radius
        button.addTarget(self, action: #selector(irregularEventButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.screenName = AnalyticsEventData.TrackersTypeScreen.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout(){
        view.backgroundColor = AppColors.Dynamic.white
        
        view.addSubview(titleLabel)
        view.addSubview(titleLabel)
        view.addSubview(habitButton)
        view.addSubview(irregularEventButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Insets.leading),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Insets.trailing),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            habitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -58),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    //MARK: - IB Outlet
    @IBAction
    private func habitButtonTapped(_ sender: UIButton) {
        Log.info(message: "reporting add habit event")
        AnalyticsService.shared.trackEvent(event: .click, params: AnalyticsEventData.TrackersTypeScreen.clickAddTracker)
        dismiss(animated: true) { [weak self] in
            guard let self else {return}
            self.delegate?.showNewHabitViewController()
        }
    }
    
    @IBAction
    private func irregularEventButtonTapped(_ sender: UIButton) {
        Log.info(message: "reporting add irregular event")
        AnalyticsService.shared.trackEvent(event: .click, params: AnalyticsEventData.TrackersTypeScreen.clickAddIrregularEvent)
        dismiss(animated: true) { [weak self] in
            guard let self else {return}
            self.delegate?.showNewIrregularEventController()
        }
    }
}
