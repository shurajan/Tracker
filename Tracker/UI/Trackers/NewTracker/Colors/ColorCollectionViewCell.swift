//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.10.2024.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    private lazy var colorBox: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    func configure(with color: UIColor, isSelected: Bool) {
        colorBox.backgroundColor = color
        let borderColor = color.withAlphaComponent(0.3)
        contentView.layer.borderWidth = isSelected ? 3 : 0
        contentView.layer.borderColor = isSelected ? borderColor.cgColor : nil
    }
    
    private func setupLayout() {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.addSubview(colorBox)
        
        NSLayoutConstraint.activate([
            colorBox.widthAnchor.constraint(equalToConstant: 40),
            colorBox.heightAnchor.constraint(equalToConstant: 40),
            colorBox.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
