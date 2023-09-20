//
//  WarningsViewController.swift
//  Warnings
//
//  Created by jonathan saville on 31/08/2023.
//

import UIKit
import Combine


// DUMMY CLASS - TBD


class WarningsViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pressMeButton: UIButton!

    public var coordinator: WarningsCoordinatorProtocol?
    public var viewModel: WarningsViewModel?
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindToViewModel()
    }

    private func initUI() {
        guard let viewModel = viewModel else { return }
        label.text = "\(viewModel.counter)"
    }
    
    private func bindToViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.$counter
             .receive(on: DispatchQueue.main)
             .map{ String($0) }
             .assign(to: \.text, on: label)
             .store(in: &cancellables)

        viewModel.$toggleButtonName
             .receive(on: DispatchQueue.main)
             .assign(to: \.normalTitleText, on: pressMeButton).store(in: &cancellables)
    }

    @IBAction func pressMeTapped(sender: UIButton) {
        viewModel?.toggleTimer()
    }
}

