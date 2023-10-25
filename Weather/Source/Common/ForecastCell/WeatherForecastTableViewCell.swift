//
//  WeatherForecastTableViewCell.swift
//  Weather
//
//  Created by jonathan saville on 02/09/2023.
//

import UIKit
import WeatherNetworkingKit

protocol WeatherForecastTableViewCellDelegate: AnyObject {
    func tappedCell(with forecast: Forecast, indexPath: IndexPath)
}

class WeatherForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFooterContainer: UIView!
    @IBOutlet weak var navigationStackView: UIStackView!
    @IBOutlet weak var scrollLeftButton: UIButton!
    @IBOutlet weak var scrollRightButton: UIButton!

    private var forecast: Forecast?
    private var collectionCellType: WeatherCollectionViewCell.Type?
    private var contentSizeObservation: NSKeyValueObservation?
    
    private weak var delegate: WeatherForecastTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .backgroundPrimary()
        selectionStyle = .none

        initCollectionView()
        initNavigationViewStack()

        // Observe the initial setting of the collectionView's contentSize, and set the enabled state of the scrollRightButton accordingly.
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
                   delegate: WeatherForecastTableViewCellDelegate,
                   collectionCellType: WeatherCollectionViewCell.Type,
                   header: UIView,
                   collectionFooter: UIView) {
        self.forecast = forecast
        self.delegate = delegate
        self.collectionCellType = collectionCellType

        collectionView.registerCell(withType: collectionCellType) // repeated registration?

        headerContainer.removeAllSubviews()
        headerContainer.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.pinEdges(to: headerContainer)

        collectionViewFooterContainer.removeAllSubviews()
        collectionViewFooterContainer.addSubview(collectionFooter)
        collectionFooter.translatesAutoresizingMaskIntoConstraints = false
        collectionFooter.pinEdges(to: collectionViewFooterContainer)
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

    private func initCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func initNavigationViewStack() {
        navigationStackView.backgroundColor = .divider() // effectively the cell separator color
        scrollLeftButton.backgroundColor = .backgroundPrimary()
        scrollLeftButton.tintColor = .button(for: .highlighted)
        scrollLeftButton.isEnabled = false
        scrollRightButton.backgroundColor = .backgroundPrimary()
        scrollRightButton.tintColor = .button(for: .highlighted)
        scrollRightButton.isEnabled = false
    }
}

extension WeatherForecastTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numVisibleCollectionItems = 5
        let width: CGFloat
        if #available(iOS 17, *) {
            // We use rounded below because iOS17 has introduced a bug (at least on the Simulator) which, very oddly, results
            // in a particular cell not being re-drawn on its first re-use - and rounding the width fixes it!
            width = (collectionView.frame.size.width / CGFloat(numVisibleCollectionItems)).rounded()
        } else {
            width = (collectionView.frame.size.width / CGFloat(numVisibleCollectionItems))
        }
        return CGSize(width: width, height: 120)
     }
}

extension WeatherForecastTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecast?.daily.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let forecast = forecast,
              let collectionCellType = collectionCellType,
              let cell: WeatherCollectionViewCell = collectionView.dequeueReusableCell(withType: collectionCellType, for: indexPath)
        else { return UICollectionViewCell() }
        
        cell.configure(with: forecast, indexPath: indexPath)
        return cell
    }
}

extension WeatherForecastTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let forecast = forecast else { return }
        delegate?.tappedCell(with: forecast, indexPath: indexPath)
    }
}

extension WeatherForecastTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleItems = collectionView.indexPathsForFullyVisibleItems.map{ $0.row }
        guard visibleItems.isEmpty == false else { return }
        
        let isFirstCellFullyVisible = visibleItems.contains(0)

        // Very odd iOS (16.6.1) bug - indexPathsForFullyVisibleItems returns the correct set of items on the siumlator
        // but NOT on a real device (it misses out the final indexPath when scrolled completely to the right). So on a real
        // device, I have to calculate 'by hand' whether there is still scrollable content to the right - but even then, I
        // need to add 1 pixel to the calculation (the bug is evidently in the sizing of the contentSize or the contentOffset).
        // All very surprising!
        #if IOS_SIMULATOR
        let isLastCellFullyVisible = visibleItems.contains(collectionView.numberOfItems(inSection: 0) - 1)
        #else
        let isLastCellFullyVisible = scrollView.contentOffset.x + scrollView.bounds.size.width + 1 > scrollView.contentSize.width
        #endif

        scrollLeftButton.isEnabled = !isFirstCellFullyVisible
        scrollRightButton.isEnabled = !isLastCellFullyVisible
    }
}
