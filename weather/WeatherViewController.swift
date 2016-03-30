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
    
    @IBOutlet var weatherInforView: WeatherInfoView!
    
    private var weekdayFormatter: NSDateFormatter!
    private var timeFormatter: NSDateFormatter!
    private var headerViewTopConstraintOriginalValue: CGFloat!
    private var distanceToFullPercent: CGFloat = 0

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
    }
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Weather", comment: "WeatherTitle")
        headerViewTopConstraintOriginalValue = headerViewTopConstraint.constant
        
        tableView.registerNib(UINib(nibName: "ForecastCell", bundle: nil), forCellReuseIdentifier: CellIdForecastCell)
        tableView.tableFooterView = weatherInforView
        
        self.updateUI()
        
        refreshData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WeatherViewController.refreshData), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var contentInset = tableView.contentInset
        contentInset.top = headerView.frame.maxY
        contentInset.bottom = 12 // extra margin
        tableView.contentInset = contentInset
        
        tableView.contentOffset = CGPoint(x: 0, y: -contentInset.top)
        
        let backgroundViewFrame = view.convertRect(headerTitleBackgroundView.frame, fromView:headerTitleBackgroundView.superview)
        distanceToFullPercent = tableView.contentInset.top - backgroundViewFrame.maxY
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
        updateWetherInfoView()
        
        cityLabel.text = shared.api.city.name
        
        if let currentWeather = shared.api.city.currentWeather  {
            tempLabel.text = currentWeather.stringValueForWeatherInfoType(.Temperature)
            weatherLabel.text = currentWeather.stringValueForWeatherInfoType(.Summary).capitalizedString
        } else {
            tempLabel.text = "--°"
            weatherLabel.text = ""
        }
    }
    
    func updateWetherInfoView() {
        
        for i in 0..<weatherInfoTitles.count {
            let type = weatherInfoTitles[i]
            let label = weatherInforView.titleLabelAtIndex(i)
            label.text = CurrentWeather.descriptionForWeatherInfoType(type) + ":"
        }
        
        if let currentWeather = shared.api.city.currentWeather {
            for i in 0..<weatherInfoTitles.count {
                let type = weatherInfoTitles[i]
                let label = weatherInforView.valueLabelAtIndex(i)
                label.text = currentWeather.stringValueForWeatherInfoType(type)
            }
        } else {
            weatherInforView.clearAllValues()
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
            return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let backgroundViewFrame = view.convertRect(headerTitleBackgroundView.frame, fromView:headerTitleBackgroundView.superview)
        let distanceToFullPercent = scrollView.contentInset.top - backgroundViewFrame.maxY
        var scrollPercent = (scrollView.contentOffset.y + scrollView.contentInset.top) / distanceToFullPercent
        if scrollPercent > 1 { scrollPercent = 1 }
        
        headerViewTopConstraint.constant = round((1 - scrollPercent) * headerViewTopConstraintOriginalValue)
        
        // alpha goes from 1 to 0 on 70% of total distance
        tempLabel.alpha = 1 - scrollPercent / 0.7
    }
}
