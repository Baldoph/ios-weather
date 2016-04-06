//
//  WeatherViewController.swift
//  weather
//
//  Created by Baldoph Pourprix on 29/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import WeatherKit

private let CellIdForecastCell = "CellIdForecastCell"

class WeatherViewController: UIViewController, BindableViewModel {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitleBackgroundView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet var weatherInfoView: WeatherInfoView!
    
    private var headerViewTopConstraintOriginalValue: CGFloat!
    /// The space between the top table view cell and the bottom of `backgroundViewFrame`
    private var distanceToFullPercent: CGFloat?
    
    let disposeBag = DisposeBag()
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
        // Set title
        title = NSLocalizedString("Weather", comment: "WeatherTitle")
        
        // Save the original value of the constraint to use in -scrollViewDidScroll:
        headerViewTopConstraintOriginalValue = headerViewTopConstraint.constant
        
        tableView.registerNib(UINib(nibName: "ForecastCell", bundle: nil), forCellReuseIdentifier: CellIdForecastCell)
        
        setUpHeaderAnimation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var contentInset = tableView.contentInset
        contentInset.top = headerView.frame.maxY // table view content won't be overlapped by header view
        contentInset.bottom = 12 // extra bottom margin
        tableView.contentInset = contentInset
        tableView.contentOffset = CGPoint(x: 0, y: -contentInset.top) // scroll to top
        
        let backgroundViewFrame = view.convertRect(headerTitleBackgroundView.frame, fromView:headerTitleBackgroundView.superview)
        // The space between the top table view cell and the bottom of `backgroundViewFrame`
        distanceToFullPercent = tableView.contentInset.top - backgroundViewFrame.maxY
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Regular {
            // In portrait the `weatherInfoView` is handled by the table view as its footer view
            weatherInfoView.removeFromSuperview()
            weatherInfoView.origin = CGPointZero
            tableView.tableFooterView = weatherInfoView
        } else if traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact {
            // In landscape we manually place the `weatherInfoView` on the right hand side of the screen
            tableView.tableFooterView = nil
            weatherInfoView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin, .FlexibleBottomMargin]
            view.addSubview(weatherInfoView)
            weatherInfoView.width = view.bounds.size.width / 2
            weatherInfoView.rightMargin = 0
            weatherInfoView.centerVertically()            
        }
    }
    
    // MARK: - Business
    
    func bindViewModel(viewModel: WeatherViewModel) {
        viewModel.cityName.asObservable().bindTo(cityLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.forecasts.asObservable().bindTo(tableView.rx_itemsWithCellIdentifier(CellIdForecastCell, cellType: ForecastCell.self)) { (row, element, cell) in
                cell.forecast = element
            }.addDisposableTo(disposeBag)
        viewModel.currentTemperatureDescription.asObservable().bindTo(tempLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.currentWeatherDescription.asObservable().bindTo(weatherLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.currentWeather.asObservable().bindTo(weatherInfoView.rx_currentWeather).addDisposableTo(disposeBag)
        
        viewModel.didBind()
    }
    
    /// Scroll to a position where the header is not halfway to top or bottom position
    func scrollToKnownPosition() {
        guard let distanceToFullPercent = distanceToFullPercent else { return }
        
        let progress = (tableView.contentOffset.y + tableView.contentInset.top) / distanceToFullPercent
        if progress < 0.5 {
            tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: true)
        } else if progress < 1.0 {
            tableView.setContentOffset(CGPoint(x: 0, y: -headerTitleBackgroundView.height - topLayoutGuide.length), animated: true)
        }
    }
}

// MARK: - ScrollView delegate methods
extension WeatherViewController: UITableViewDelegate {
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToKnownPosition()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if !scrollView.tracking {
            scrollToKnownPosition()
        }
    }
}

// MARK: - Animations
extension WeatherViewController {
    private func setUpHeaderAnimation() {
        // Compute progress between bottom (table view is scrolled up) and top (is scrolled down) positions of header view
        let scrollProgress = tableView.rx_contentOffset.asDriver().map { (offset) -> CGFloat in
            guard let distanceToFullPercent = self.distanceToFullPercent else {
                return 0
            }
            var progress = (offset.y + self.tableView.contentInset.top) / distanceToFullPercent
            if progress > 1 { progress = 1 }
            return progress
        }
        
        // Move header to top or bottom position proportionally to progress
        scrollProgress.map { roundScreen((1 - $0) * self.headerViewTopConstraintOriginalValue) }.drive(self.headerViewTopConstraint.rx_constant).addDisposableTo(disposeBag)
        
        // Alpha of temperature label goes from 1 to 0 when progress goes from 0 to 70%
        scrollProgress.map { 1 - $0 / 0.7 }.drive( self.tempLabel.rx_alpha ).addDisposableTo(disposeBag)
    }
}
