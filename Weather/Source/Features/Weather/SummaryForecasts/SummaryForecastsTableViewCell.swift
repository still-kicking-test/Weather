//
//  SummaryForecastsTableViewCell.swift
//  Weather
//
//  Created by jonathan saville on 02/09/2023.
//

import UIKit

protocol SummaryForecastsTableViewCellDelegate: AnyObject {
    func tappedCell(with forecast: Forecast, day: Int)
}

class SummaryForecastsTableViewCell: UITableViewCell {
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var fullForecastButton: UIButton!
    @IBOutlet weak var navigationStackView: UIStackView!
    @IBOutlet weak var scrollLeftButton: UIButton!
    @IBOutlet weak var scrollRightButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var forecast: Forecast?
    private var contentSizeObservation: NSKeyValueObservation?
    private weak var delegate: SummaryForecastsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .backgroundPrimary()
        selectionStyle = .none

        initButtons()
        initCollectionView()
        initNavigationViewStack()

        // Observe the initial setting of the collectionView's contentSize, and set the enabled state of the crollRightButton accordingly.
        contentSizeObservation = collectionView.observe(\.contentSize) { [weak self] _, _ in
            guard let self else { return }
            scrollRightButton.isEnabled = forecast?.daily.count ?? 0 > 0
            self.contentSizeObservation?.invalidate()
            self.contentSizeObservation = nil
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    func configure(with forecast: Forecast,
                   delegate: SummaryForecastsTableViewCellDelegate) {
        self.forecast = forecast
        self.delegate = delegate
        let title: String
        if let location = forecast.location {
            let state = location.state.isEmpty ? "" : " (\(location.state))"
            title = "\(location.name)\(state)"
        } else {
            title = "<unknown>"
        }
        locationButton.normalTitleText = title
        collectionView.reloadData()
    }
    
    @IBAction func fullForecastButtonTapped(sender: UIButton) {
        guard let forecast = forecast else { return }
        delegate?.tappedCell(with: forecast, day: 0)
    }
    
    @IBAction func locationButtonTapped(sender: UIButton) {
        guard let forecast = forecast else { return }
        delegate?.tappedCell(with: forecast, day: 0)
    }
    
    @IBAction func scrollLeftButtonTapped(sender: UIButton) {
        guard let lhsIndexPath = (collectionView.indexPathsForFullyVisibleItems.sorted {$0.row < $1.row}).first,
              let previousIndexPath = lhsIndexPath.previousRow else { return }
        collectionView.scrollToItem(at: previousIndexPath, at: .right, animated: true)
    }
    
    @IBAction func scrollRightButtonTapped(sender: UIButton) {
        guard let rhsIndexPath = (collectionView.indexPathsForFullyVisibleItems.sorted {$0.row < $1.row}).last else { return }
        let nextIndexPath = rhsIndexPath.nextRow
        if nextIndexPath.row < collectionView.numberOfItems(inSection: 0) {
            collectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        }
    }
    
    private func initButtons() {
        fullForecastButton.normalTitleText = "View full forecast"
        fullForecastButton.configure(baseForegroundColor: .button(for: .highlighted))
        locationButton.configure(baseForegroundColor: .defaultText())
    }

    private func initCollectionView() {
        collectionView.registerCell(withType: SummaryForecastCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func initNavigationViewStack() {
        navigationStackView.backgroundColor = .backgroundTertiary() // effectively the cell separator color
        scrollLeftButton.backgroundColor = .backgroundPrimary()
        scrollLeftButton.tintColor = .button(for: .highlighted)
        scrollLeftButton.isEnabled = false
        scrollRightButton.backgroundColor = .backgroundPrimary()
        scrollRightButton.tintColor = .button(for: .highlighted)
        scrollRightButton.isEnabled = false
    }
}

extension SummaryForecastsTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numVisibleCollectionItems = 5
        return CGSize(width: collectionView.frame.size.width / CGFloat(numVisibleCollectionItems), height: 120)
    }
}

extension SummaryForecastsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecast?.daily.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let forecast = forecast,
              let cell: SummaryForecastCollectionViewCell = collectionView.dequeueReusableCell(withType: SummaryForecastCollectionViewCell.self, for: indexPath)
        else { return UICollectionViewCell() }
        
        cell.configure(with: forecast.daily[indexPath.row])
        return cell
    }
}

extension SummaryForecastsTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let forecast = forecast else { return }
        delegate?.tappedCell(with: forecast, day: indexPath.row)
    }
}

extension SummaryForecastsTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleItems = collectionView.indexPathsForFullyVisibleItems.map{ $0.row }
        guard visibleItems.isEmpty == false else { return }
        
        scrollLeftButton.isEnabled = !visibleItems.contains(0)
        scrollRightButton.isEnabled = !visibleItems.contains(collectionView.numberOfItems(inSection: 0) - 1)
    }
}
