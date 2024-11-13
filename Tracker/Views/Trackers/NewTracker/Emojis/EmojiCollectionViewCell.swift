//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.10.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.emojiFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        contentView.backgroundColor = isSelected ? .ysLightGray : .clear
    }
    
    private func setupLayout() {
        contentView.addSubview(emojiLabel)
        contentView.layer.cornerRadius = Constants.radius
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
