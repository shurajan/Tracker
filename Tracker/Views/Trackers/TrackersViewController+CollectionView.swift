//
//  TrackersViewController+CollectionView.swift.swift
//  Tracker
//
//  Created by Alexander Bralnin on 18.11.2024.
//
import UIKit

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewModel?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell,
              let tracker = collectionViewModel?.item(at: indexPath),
              let trackerRecordStore
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(tracker: tracker, date: selectedDate.startOfDay(), dataProvider: trackerRecordStore)
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? UICollectionReusableView,
                  let dataProvider = collectionViewModel,
                  let sectionTitle = dataProvider.titleForSection(indexPath.section) else {
                return UICollectionReusableView()
            }
            
            let label = UILabel(frame: headerView.bounds)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = sectionTitle
            label.textAlignment = .left
            label.textColor = .ysBlack
            label.font = Fonts.sectionHeaderFont
            
            headerView.subviews.forEach { $0.removeFromSuperview() }
            headerView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 28),
                label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: Insets.top),
            ])
            
            return headerView
        }
        return UICollectionReusableView()
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth,
                      height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: params.leftInset, bottom: 10, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
