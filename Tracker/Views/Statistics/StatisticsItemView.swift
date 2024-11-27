//
//  StatisticsItemView.swift
//  Tracker
//
//  Created by Alexander Bralnin on 22.11.2024.
//

import UIKit

final class StatisticsItemView: GradientBorderView {
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.titleLargeFont
        label.textColor = AppColors.Dynamic.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.labelFont
        label.textColor = AppColors.Dynamic.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(value: String, description: String) {
        super.init(frame: .zero)
        self.valueLabel.text = value
        self.descriptionLabel.text = description
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(valueLabel)
        addSubview(descriptionLabel)
        
        self.borderWidth = 1.0
        self.cornerRadius = Constants.radius
        self.gradientColors = [
            UIColor(hex: "#007BFA"),
            UIColor(hex: "#46E69D"),
            UIColor(hex: "#FD4C49")
        ]
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 7),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
