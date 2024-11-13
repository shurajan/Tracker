//
//  PlaceHolderView.swift
//  Tracker
//
//  Created by Alexander Bralnin on 13.11.2024.
//

import UIKit

final class PlaceHolderView: UIView {
    
    private let dizzyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Dizzy"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
    
    func setText(text: String) {
        questionLabel.text = text
    }
    
    private func setupLayout() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dizzyImageView)
        addSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            dizzyImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dizzyImageView.topAnchor.constraint(equalTo: topAnchor),
            dizzyImageView.widthAnchor.constraint(equalToConstant: 80),
            dizzyImageView.heightAnchor.constraint(equalToConstant: 80),
            
            questionLabel.topAnchor.constraint(equalTo: dizzyImageView.bottomAnchor, constant: 8),
            questionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            questionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
