//
//  WeatherViewController.swift
//  weather
//
//  Created by Baldoph Pourprix on 29/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit

private let CellIdForecastCell = "CellIdForecastCell"

class WeatherViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitleBackgroundView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet var weatherInfoView: WeatherInfoView!
    
    private var weekdayFormatter: NSDateFormatter!
    private var timeFormatter: NSDateFormatter!
    private var headerViewTopConstraintOriginalValue: CGFloat!
    /// The space between the top table view cell and the bottom of `backgroundViewFrame`
    private var distanceToFullPercent: CGFloat!
    private var weatherInfoTitles: [WeatherInfoType] = [.Sunrise, .Sunset, .Clouds, .Rain, .Humidity, .Pressure]
    
    // MARK: - Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    func commonInit() {
        weekdayFormatter = NSDateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = .ShortStyle
        // Refresh data when app enters foreground
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WeatherViewController.refreshData), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        title = NSLocalizedString("Weather", comment: "WeatherTitle")
        
        // Save the original value of the constraint to use in -scrollViewDidScroll:
        headerViewTopConstraintOriginalValue = headerViewTopConstraint.constant
        
        tableView.registerNib(UINib(nibName: "ForecastCell", bundle: nil), forCellReuseIdentifier: CellIdForecastCell)
        
        self.updateUI()
        refreshData()
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
    
    func refreshData() {
        shared.api.updateWeather { (error) in
            if error == nil {
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        tableView.reloadData()
        updateWeatherInfoView()
        
        cityLabel.text = shared.api.city.name
        
        if let currentWeather = shared.api.city.currentWeather  {
            tempLabel.text = currentWeather.stringValueForWeatherInfoType(.Temperature)
            weatherLabel.text = currentWeather.stringValueForWeatherInfoType(.Summary).capitalizedString
        } else {
            tempLabel.text = "--°"
            weatherLabel.text = ""
        }
    }
    
    func updateWeatherInfoView() {
        
        for i in 0..<weatherInfoTitles.count {
            let type = weatherInfoTitles[i]
            let label = weatherInfoView.titleLabelAtIndex(i)
            label.text = CurrentWeather.descriptionForWeatherInfoType(type) + ":"
        }
        
        if let currentWeather = shared.api.city.currentWeather {
            for i in 0..<weatherInfoTitles.count {
                let type = weatherInfoTitles[i]
                let label = weatherInfoView.valueLabelAtIndex(i)
                label.text = currentWeather.stringValueForWeatherInfoType(type)
            }
        } else {
            weatherInfoView.clearAllValues()
        }
    }
    
    /// Scroll to a position where the header is not halfway to top or bottom position
    func scrollToKnownPosition() {
        guard distanceToFullPercent != nil else { return }
        
        let progress = (tableView.contentOffset.y + tableView.contentInset.top) / distanceToFullPercent
        if progress < 0.5 {
            tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: true)
        } else if progress < 1.0 {
            tableView.setContentOffset(CGPoint(x: 0, y: -headerTitleBackgroundView.height - topLayoutGuide.length), animated: true)
        }
    }
}

// MARK: - Table View protocols
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let daysForecasts = shared.api.city.daysForecasts {
            return daysForecasts.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdForecastCell) as! ForecastCell
        let forecast = shared.api.city.daysForecasts![indexPath.row]
        cell.dayLabel.text = weekdayFormatter.stringFromDate(forecast.date)
        cell.maxTempLabel.text = "\(Int(round(forecast.temperatureMax.floatValue)))"
        cell.minTempLabel.text = "\(Int(round(forecast.temperatureMin.floatValue)))"
        if indexPath.row == 0 {
            cell.today = true
        } else {
            cell.today = false
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        guard distanceToFullPercent != nil else { return }
        
        var progress = (scrollView.contentOffset.y + scrollView.contentInset.top) / distanceToFullPercent
        if progress > 1 { progress = 1 }
        
        // Move header to top or bottom position proportionally to progress
        headerViewTopConstraint.constant = roundScreen((1 - progress) * headerViewTopConstraintOriginalValue)
        
        // Alpha goes from 1 to 0 when progress goes from 0 to 70%
        tempLabel.alpha = 1 - progress / 0.7
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToKnownPosition()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollToKnownPosition()
    }
}
