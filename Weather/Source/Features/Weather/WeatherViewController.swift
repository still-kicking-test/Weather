//
//  WeatherViewController.swift
//  Weather
//
//  Created by jonathan saville on 31/08/2023.
//

import UIKit
import Combine

class WeatherViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    public var coordinator: WeatherCoordinatorProtocol?
    public var viewModel: WeatherViewModel?
    
    private var summaryForecastsTableController: SummaryForecastsTableController?
    private var cancellables = Set<AnyCancellable>()
    private var busyViewController = BusyViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bind()
        extendedLayoutIncludesOpaqueBars = true
    }

    private func initUI() {
        view.backgroundColor = .clear
        navigationItem.title = "Weather"
        
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(didTapSettingsButton))
        let editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEditButton))
        navigationItem.leftBarButtonItem = settingsBarButtonItem
        navigationItem.rightBarButtonItem = editBarButtonItem
        
        summaryForecastsTableController = SummaryForecastsTableController(tableView: tableView, viewModel: viewModel, delegate: self)
    }

    private func bind() {
        viewModel?.$isLoading
             .receive(on: DispatchQueue.main)
             .sink{ [weak self] isLoading in
                 guard let self else { return }
                 busyViewController.isHidden(!isLoading, in: self)
             }
             .store(in: &cancellables)

        viewModel?.$generalError
             .receive(on: DispatchQueue.main)
             .sink{ [weak self] error in
                 guard let self, let error = error else { return }
                 showDismissableError(message: error.localizedDescription)
             }
             .store(in: &cancellables)
    }

    @objc
    private func didTapEditButton(sender: UIButton) {
        coordinator?.showEdit()
    }
    
    @objc
    private func didTapSettingsButton(sender: UIButton) {
        coordinator?.showSettings()
    }
}

extension WeatherViewController: SummaryForecastsTableControllerDelegate {
    
    func tappedSummary(_ forecast: Forecast, day: Int) {
        coordinator?.showFullForecast(forecast, day: day)
    }
}
