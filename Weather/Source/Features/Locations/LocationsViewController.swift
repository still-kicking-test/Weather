//
//  LocationsViewController.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import UIKit
import Combine

class LocationsViewController: UIViewController {

     public var viewModel: LocationsViewModel?
     
     @IBOutlet weak var collectionView: UICollectionView!
     
     private var locationsCollectionController: LocationsCollectionController?
     private var cancellables = Set<AnyCancellable>()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         initUI()
         bind()
     }
     
     private func initUI() {
         view.backgroundColor = .clear
         navigationItem.title = "Weather"
     
         let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton))
         navigationItem.rightBarButtonItem = doneBarButtonItem
         navigationItem.setHidesBackButton(true, animated: false)
         locationsCollectionController = LocationsCollectionController(collectionView: collectionView, viewModel: viewModel)
     }
     
     private func bind() {
         viewModel?.$generalError
             .receive(on: DispatchQueue.main)
             .sink{ [weak self] error in
                 guard let self, let error = error else { return }
                 showDismissableError(message: error.localizedDescription)
             }
             .store(in: &cancellables)

         viewModel?.$isUpdated
             .receive(on: DispatchQueue.main)
             .sink{ [weak self] error in
                 guard let self else { return }
                 self.reloadData()
             }
             .store(in: &cancellables)
     }
     
     @objc private func didTapDoneButton(sender: UIButton) {
         viewModel?.saveChanges()
         navigationController?.popViewController(animated: false)
     }
    
     @objc private func reloadData() {
        collectionView.reloadData()
     }
}
