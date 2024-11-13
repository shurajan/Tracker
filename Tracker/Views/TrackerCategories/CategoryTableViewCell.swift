//
//  CategoryCell.swift
//  Tracker
//
//  Created by Alexander Bralnin on 12.11.2024.
//
import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    let trackerLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.titleMediumFont
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(trackerLabel)
        contentView.addSubview(selectedImageView)
        
        NSLayoutConstraint.activate([
            selectedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            selectedImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectedImageView.widthAnchor.constraint(equalToConstant: 24),
            selectedImageView.heightAnchor.constraint(equalToConstant: 24),
            
            trackerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            trackerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trackerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    
    func configure(text: String, isSelected: Bool) {
        trackerLabel.text = text
        selectedImageView.image = isSelected ? UIImage(named: "Done") : nil
    }
}
