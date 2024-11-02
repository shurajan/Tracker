//
//  ColorSelectionView.swift.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.10.2024.
//

// ColorSelectionView.swift

// ColorSelectionView.swift

import UIKit

class ColorSelectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    weak var delegate: NewTrackerDelegateProtocol?
    
    private var selectedColorIndex: IndexPath?
    
    private let params: GeometricParams = GeometricParams(cellCount: 6,
                                                          leftInset: 20,
                                                          rightInset: 20,
                                                          cellSpacing: 5)

    
    // Заголовок для секции с цветами
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // UICollectionView для цветов
    private lazy var colorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .ysWhite
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(colorLabel)
        addSubview(colorCollectionView)
        
        NSLayoutConstraint.activate([
            colorLabel.topAnchor.constraint(equalTo: topAnchor),
            colorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            colorLabel.heightAnchor.constraint(equalToConstant: 18),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor),
            colorCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 204),
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TrackerColor.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let color = TrackerColor.allCases[indexPath.item].uiColor
        let isSelected = indexPath == selectedColorIndex
        cell.configure(with: color, isSelected: isSelected)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth,
                      height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: params.leftInset, bottom: 24, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndex = selectedColorIndex, let previousCell = collectionView.cellForItem(at: previousIndex) as? ColorCollectionViewCell {
            previousCell.configure(with: TrackerColor.allCases[previousIndex.item].uiColor, isSelected: false)
        }
        
        selectedColorIndex = indexPath
        delegate?.didSelectColor(indexPath)
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
            currentCell.configure(with: TrackerColor.allCases[indexPath.item].uiColor, isSelected: true)
        }
    }
}
