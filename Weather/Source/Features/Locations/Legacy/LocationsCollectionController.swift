//
//  LocationsCollectionController.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import UIKit
import Combine

class LocationsCollectionController: NSObject {
    
    private let viewModel: LocationsViewModel?
    private var cancellables = Set<AnyCancellable>()
    private let collectionView: UICollectionView

    init(collectionView: UICollectionView,
         viewModel: LocationsViewModel?) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        super.init()
        initUI()
    }
    
    private func initUI() {
        collectionView.registerCell(withType: LocationCollectionViewCell.self)
        collectionView.registerCell(withType: SelectableCollectionViewCell.self)
        collectionView.registerCell(withType: SearchCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
     }
}

extension LocationsCollectionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}

extension LocationsCollectionController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.displayItemsCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let displayItem = viewModel?.displayItem(forIndex: indexPath.row) else { return UICollectionViewCell() }
        
        switch displayItem {
        case .search:
            guard let cell: SearchCollectionViewCell = collectionView.dequeueReusableCell(withType: SearchCollectionViewCell.self, for: indexPath)
            else { return UICollectionViewCell() }
            
            cell.configure(with: LocationsDisplayItem.searchPlaceholder, delegate: self)
            return cell
            
        case .currentLocation(let isEnabled):
            guard let cell: SelectableCollectionViewCell = collectionView.dequeueReusableCell(withType: SelectableCollectionViewCell.self, for: indexPath)
            else { return UICollectionViewCell() }
            
            cell.configure(with: isEnabled, text: CommonStrings.currentLocation, for: indexPath, delegate: self)
            return cell
            
        case .location(let value):
            guard let cell: LocationCollectionViewCell = collectionView.dequeueReusableCell(withType: LocationCollectionViewCell.self, for: indexPath)
            else { return UICollectionViewCell() }
            
            cell.configure(with: value, delegate: self)
            return cell
            
        case .video(let isEnabled):
            guard let cell: SelectableCollectionViewCell = collectionView.dequeueReusableCell(withType: SelectableCollectionViewCell.self, for: indexPath)
            else { return UICollectionViewCell() }
            
            cell.configure(with: isEnabled, text:  LocationsDisplayItem.videoTitle, for: indexPath, delegate: self)
            return cell
        }
    }
}

extension LocationsCollectionController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        guard let viewModel = viewModel else { return originalIndexPath }
        return viewModel.canMoveItemAt(proposedIndexPath) ? proposedIndexPath : originalIndexPath
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let displayItem = viewModel?.displayItem(forIndex: indexPath.row),
              case .location = displayItem else { return [] } // only allow dynamic locations to be moved, not switchable rows such as .video and .current
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = displayItem
        return [dragItem]
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let viewModel = viewModel,
              let item = coordinator.items.first,
              let sourceIndexPath = item.sourceIndexPath,
              let destinationIndexPath = coordinator.destinationIndexPath,
              viewModel.canMoveItemAt(destinationIndexPath) else { return }

        collectionView.performBatchUpdates({
            viewModel.moveLocationAt(sourceIndexPath, to: destinationIndexPath)
            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])
        })
    }
}

extension LocationsCollectionController: SelectableCollectionViewCellDelegate {
    func cell(_ cell: SelectableCollectionViewCell, didChangeSelectableValueTo newValue: Bool) {
        guard let viewModel = viewModel,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        viewModel.valueDidChangeAt(indexPath, with: newValue)
    }
}

extension LocationsCollectionController: LocationCollectionViewCellDelegate {
    func didTapDeleteForCell(_ cell: LocationCollectionViewCell) {
        guard let viewModel = viewModel,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        viewModel.deleteLocationAt(indexPath)
    }
}

extension LocationsCollectionController: SearchCollectionViewCellDelegate {
    // Until we have a decent city search API, the search field is just a tappable button
    func searchTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.searchTapped()
    }
}
