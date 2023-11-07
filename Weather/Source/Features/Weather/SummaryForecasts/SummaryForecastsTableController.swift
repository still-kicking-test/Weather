//
//  SummaryForecastsTableController.swift
//  Weather
//
//  Created by jonathan saville on 03/09/2023.
//

import Foundation
import UIKit
import Combine
import WeatherNetworkingKit

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
        tableView.registerCell(withType: WeatherForecastTableViewCell.self)
        tableView.registerCell(withType: InlineMessageTableViewCell.self)
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
            guard let cell: WeatherForecastTableViewCell = tableView.dequeueReusableCell(withType: WeatherForecastTableViewCell.self, for: indexPath)
            else { return UITableViewCell() }
            
            let header = UIButton(title: forecast.location?.fullName ?? "<unknown>",
                                  attributes: AttributeContainer([NSAttributedString.Key.backgroundColor: UIColor.backgroundPrimary(),
                                                                  NSAttributedString.Key.foregroundColor: UIColor.defaultText(),
                                                                  NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]),
                                  isUserInteractionEnabled: false)
         
            let collectionFooter = UIButton(title: "View full forecast")
            collectionFooter.backgroundColor =  UIColor.backgroundPrimary()
            collectionFooter.tag = indexPath.section
            collectionFooter.addTarget(self, action: #selector(tappedCollectionFooter(_:)), for: .touchUpInside)
            
            cell.configure(with: forecast, delegate: self, collectionCellType: SummaryForecastCollectionViewCell.self, header: header, collectionFooter: collectionFooter)
            return cell
            
        case .video(let title, let url):
            guard let cell: WebViewTableViewCell = tableView.dequeueReusableCell(withType: WebViewTableViewCell.self, for: indexPath)
            else { return UITableViewCell() }
            
            cell.configure(with: title, url: url)
            return cell
            
        case .inlineMessage(let inlineMessage):
            guard let cell: InlineMessageTableViewCell = tableView.dequeueReusableCell(withType: InlineMessageTableViewCell.self, for: indexPath)
            else { return UITableViewCell() }
            
            cell.configure(with: inlineMessage)
            return cell
       }
    }
    
    @objc
    private func tappedCollectionFooter(_ sender: Any) {
        guard let sender = sender as? UIButton,
              let displayItem = viewModel?.displayItem(forIndex: sender.tag),
              case .location(let forecast) = displayItem else { return }
    
        delegate.tappedSummary(forecast, day: 0)
    }
}

extension SummaryForecastsTableController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == tableView.numberOfSections - 1 ? 80 : 10 // add some space at the bottom of the table
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        cellSeparatorView
    }
}

extension SummaryForecastsTableController: WeatherForecastTableViewCellDelegate {
    
    func tappedCell(with forecast: Forecast, indexPath: IndexPath) {
        delegate.tappedSummary(forecast, day: indexPath.row)
    }
}
