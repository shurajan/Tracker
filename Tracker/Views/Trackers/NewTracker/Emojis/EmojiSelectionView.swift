//
//  EmojiSelectionView.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.10.2024.
//

import UIKit

final class EmojiSelectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    weak var delegate: NewTrackerDelegateProtocol?
    
    private var selectedEmojiIndex: IndexPath?
    
    private let params: GeometricParams = GeometricParams(cellCount: 6,
                                                          leftInset: 20,
                                                          rightInset: 20,
                                                          cellSpacing: 5)

    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.font = Fonts.sectionHeaderFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .ysWhite
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(emojiLabel)
        addSubview(emojiCollectionView)
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: topAnchor),
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            emojiLabel.heightAnchor.constraint(equalToConstant: 18),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            emojiCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Emoji.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell",
                                                            for: indexPath) as? EmojiCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let emoji = Emoji.allCases[indexPath.item]
        let isSelected = indexPath == selectedEmojiIndex
        cell.configure(with: emoji.rawValue, isSelected: isSelected)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth,
                      height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: Insets.top, left: params.leftInset, bottom: Insets.bottom, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Снимаем выделение с предыдущей выбранной ячейки, если она есть
        if let previousIndex = selectedEmojiIndex,
           let previousCell = collectionView.cellForItem(at: previousIndex) as? EmojiCollectionViewCell {
            previousCell.configure(with: Emoji.allCases[previousIndex.item].rawValue, isSelected: false)
        }
        
        selectedEmojiIndex = indexPath
        delegate?.didSelectEmoji(indexPath)
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell {
            currentCell.configure(with: Emoji.allCases[indexPath.item].rawValue, isSelected: true)
        }
    }
}
