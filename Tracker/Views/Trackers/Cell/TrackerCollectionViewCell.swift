//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Alexander Bralnin on 16.10.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    private var tracker: Tracker?
    private var date: Date?
    private var dataProvider: TrackerRecordDataProviderProtocol?
    
    private var count: Int = 0
    private var isDone: Bool = false
    
    var mainView: UIView {
        return cardView
    }
    
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.labelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cardView: TrackerCardView = {
        return TrackerCardView()
    }()
    
    func configure(tracker: Tracker, date: Date , dataProvider: TrackerRecordDataProviderProtocol) {
        self.dataProvider = dataProvider
        self.date = date
        self.tracker = tracker
        
        cardView.emojiLabel.text = tracker.emoji.rawValue
        cardView.nameLabel.text = tracker.name
        cardView.backgroundColor = tracker.color.uiColor
        
        let trackerRecord = TrackerRecord(trackerId: tracker.id, date: date)
        updateStatisticsAndShow(trackerRecord: trackerRecord)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateAppearance(isHighlighted: isHighlighted)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateAppearance(isHighlighted: isSelected)
        }
    }
    
    private func updateAppearance(isHighlighted: Bool) {
        let blurAlpha: CGFloat = isHighlighted ? 0.5 : 1.0
        
        UIView.animate(withDuration: 0.3) {
            self.cardView.emojiLabel.alpha = blurAlpha
            self.cardView.nameLabel.alpha = blurAlpha
            self.daysLabel.alpha = blurAlpha
            self.plusButton.alpha = blurAlpha
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(cardView)
        contentView.addSubview(daysLabel)
        contentView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            plusButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            
            daysLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            daysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
        ])
    }
    
    private func setupPlusButton(isDone: Bool, color: UIColor) {
        if let date {
            let isActive = date < Date()
            plusButton.alpha = isActive ? 0.7 : 1
            plusButton.isEnabled = isActive
        }
        
        let buttonImage = isDone ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "plus.circle.fill")
        
        plusButton.setImage(buttonImage, for: .normal)
        plusButton.tintColor = color
        plusButton.alpha = isDone ? 0.7 : 1
        
        plusButton.contentVerticalAlignment = .fill
        plusButton.contentHorizontalAlignment = .fill
        plusButton.imageView?.contentMode = .scaleAspectFit
        plusButton.imageEdgeInsets = .zero
    }
    
    private func updateStatisticsAndShow(trackerRecord: TrackerRecord) {
        guard
            let dataProvider,
            let tracker
        else { return }
        
        
        isDone = dataProvider.exist(trackerRecord: trackerRecord)
        count = dataProvider.count(by: trackerRecord.trackerId)
        
        setupPlusButton(isDone: isDone, color: tracker.color.uiColor)
        daysLabel.text = LocalizedStrings.TrackerCell.formatDaysText(days: count)
    }
    
    @IBAction
    private func plusButtonTapped() {
        guard let tracker,
              let dataProvider,
              let date,
              date < Date()
        else { return }
        
        Log.info(message: "reporting track event")
        AnalyticsService.shared.trackEvent(event: .click, params: AnalyticsEventData.MainScreen.clickTracker)
        
        let trackerRecord = TrackerRecord(trackerId: tracker.id, date: date)
        dataProvider.manageTrackerRecord(trackerRecord: trackerRecord)
        
        updateStatisticsAndShow(trackerRecord: trackerRecord)
    }
}
