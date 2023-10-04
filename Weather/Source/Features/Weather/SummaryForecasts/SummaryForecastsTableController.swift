//
//  SummaryForecastsTableController.swift
//  Weather
//
//  Created by jonathan saville on 03/09/2023.
//

import Foundation
import UIKit
import Combine

protocol SummaryForecastsTableControllerDelegate: NSObject {
    func tappedSummary(_ forecast: Forecast, day: Int)
}

class SummaryForecastsTableController: NSObject {
    
    private let viewModel: WeatherViewModel?
    private var cancellables = Set<AnyCancellable>()
    private let tableView: UITableView
    private var cellSeparatorView = UIView()
    private var delegate: SummaryForecastsTableControllerDelegate
    
    init(tableView: UITableView,
         viewModel: WeatherViewModel?,
         delegate: SummaryForecastsTableControllerDelegate) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.delegate = delegate
        super.init()
        initUI()
        bind()
    }
    
    private func initUI() {
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(withType: WebViewTableViewCell.self)
        tableView.registerCell(withType: SummaryForecastsTableViewCell.self)
    }
    
    private func bind() {
        viewModel?.$forecast
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension SummaryForecastsTableController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.displayItemCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let displayItem = viewModel?.displayItem(forIndex: indexPath.section) else { return UITableViewCell() }
        
        switch displayItem {
        case .location(let forecast):
            guard let cell: SummaryForecastsTableViewCell = tableView.dequeueReusableCell(withType: SummaryForecastsTableViewCell.self, for: indexPath)
            else { return UITableViewCell() }

            cell.configure(with: forecast, delegate: self)
            return cell
            
        case .video(let title, let url):
            guard let cell: WebViewTableViewCell = tableView.dequeueReusableCell(withType: WebViewTableViewCell.self, for: indexPath)
            else { return UITableViewCell() }
            
            cell.configure(with: title, url: url)
            return cell
       }
    }
}

extension SummaryForecastsTableController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == tableView.numberOfSections - 1 ? 80 : 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        cellSeparatorView
    }
}

extension SummaryForecastsTableController: SummaryForecastsTableViewCellDelegate {
    
    func tappedCell(with forecast: Forecast, day: Int) {
        delegate.tappedSummary(forecast, day: day)
    }
}
