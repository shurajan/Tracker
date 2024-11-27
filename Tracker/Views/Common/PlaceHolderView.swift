//
//  PlaceHolderView.swift
//  Tracker
//
//  Created by Alexander Bralnin on 13.11.2024.
//

import UIKit

final class PlaceHolderView: UIView {
    
    private let defaultImage = UIImage(named: "Dizzy")
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: defaultImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.labelFont
        label.numberOfLines = 0
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
    
    func setImage(name: String) {
        imageView.image = UIImage(named: name)
    }
    
    func setText(text: String) {
        label.text = text
    }
    
    private func setupLayout() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.leading),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Insets.trailing),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
