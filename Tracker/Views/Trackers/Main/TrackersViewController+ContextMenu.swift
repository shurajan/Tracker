//
//  TrackersViewController+ContextMenu.swift
//  Tracker
//
//  Created by Alexander Bralnin on 18.11.2024.
//
import UIKit

extension TrackersViewController {
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ in
            self.makeContextMenu(for: indexPath)
        }
    }
        
    func collectionView(
        _ collectionView: UICollectionView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: cell.mainView.bounds, cornerRadius: cell.mainView.layer.cornerRadius)
        
        return UITargetedPreview(view: cell.mainView, parameters: parameters)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: cell.mainView.bounds, cornerRadius: cell.mainView.layer.cornerRadius)
        
        return UITargetedPreview(view: cell.mainView, parameters: parameters)
    }
    
    private func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
        let pinAction = UIAction(
            title: LocalizedStrings.Trackers.ContextMenu.pin) { _ in
                self.pinItem(at: indexPath)
            }
        
        let unpinAction = UIAction(
            title: LocalizedStrings.Trackers.ContextMenu.unpin) { _ in
                self.unpinItem(at: indexPath)
            }
        
        let editAction = UIAction(
            title: LocalizedStrings.Trackers.ContextMenu.edit) { _ in
                self.editItem(at: indexPath)
            }
        
        let deleteAction = UIAction(title: LocalizedStrings.Trackers.ContextMenu.delete,
                                    attributes: .destructive) { _ in
            self.deleteItem(at: indexPath)
        }
        
        return UIMenu(title: "", children: [pinAction, unpinAction ,editAction, deleteAction])
    }
    
    private func pinItem(at indexPath: IndexPath) {
        print("Pin item at \(indexPath.row)")
    }
    
    private func unpinItem(at indexPath: IndexPath) {
        print("Unpin item at \(indexPath.row)")
    }
    
    private func editItem(at indexPath: IndexPath) {
        print("Edit item at \(indexPath.row)")
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        print("Delete item at \(indexPath.row)")
    }
    
}
