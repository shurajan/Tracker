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
        guard let tracker = viewModel?.item(at: indexPath)
        else {
            Log.warn(message: "failed to find item at \(indexPath.row)")
            return UIMenu()
        }
        
        
        let pinMessage = tracker.isPinned ? LocalizedStrings.Trackers.ContextMenu.unpin : LocalizedStrings.Trackers.ContextMenu.pin
        
        let pinAction = UIAction(
            title: pinMessage) { _ in
                self.pinItem(at: indexPath)
            }
        
        let editAction = UIAction(
            title: LocalizedStrings.Trackers.ContextMenu.edit) { _ in
                self.editItem(at: indexPath)
            }
        
        let deleteAction = UIAction(title: LocalizedStrings.Trackers.ContextMenu.delete,
                                    attributes: .destructive) { _ in
            self.deleteItem(at: indexPath)
        }
        
        return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
    }
    
    private func pinItem(at indexPath: IndexPath) {
        guard let tracker = viewModel?.item(at: indexPath)
        else {
            Log.warn(message: "failed to find item at \(indexPath.row)")
            return
        }
        viewModel?.togglePinned(trackerID: tracker.id)
    }
    
    private func unpinItem(at indexPath: IndexPath) {
        print("Unpin item at \(indexPath.row)")
    }
    
    private func editItem(at indexPath: IndexPath) {
        print("Edit item at \(indexPath.row)")
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        guard let tracker = viewModel?.item(at: indexPath)
        else {
            Log.warn(message: "failed to find item at \(indexPath.row)")
            return
        }
        
        if let viewModel {
            self.showDeleteAlert(for: tracker.id, onDelete: viewModel.deleteTracker)
        }
    }
    
    private func showDeleteAlert(for id: UUID, onDelete: @escaping (UUID) -> Void) {
        let alertController = UIAlertController(
            title: "Уверены что хотите удалить трекер?",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            onDelete(id)
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
}