//
//  CardView.swift
//  Tracker
//
//  Created by Alexander Bralnin on 18.11.2024.
//

import UIKit

final class TrackerCardView: UIView {
    
    // MARK: - Subviews
    
    lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.titleMediumFont
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.labelFont
        label.textColor = .ysWhite
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
        setupLayout()
    }
    
    // MARK: - Private Methods
    
    private func setupAppearance() {
        self.layer.cornerRadius = Constants.radius
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        addSubview(emojiLabel)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
}
