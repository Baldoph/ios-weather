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
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet var weatherInforView: WeatherInfoView!
    
    private var weekdayFormatter: NSDateFormatter!
    private var timeFormatter: NSDateFormatter!
    
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
        
        tableView.registerNib(UINib(nibName: "ForecastCell", bundle: nil), forCellReuseIdentifier: CellIdForecastCell)
        tableView.tableFooterView = weatherInforView
        
        var contentInset = tableView.contentInset
        contentInset.top += headerView.bounds.size.height
        tableView.contentInset = contentInset
        
        self.updateUI()
        
        shared.api.updateWeather { (error) in
            if error == nil {
                self.updateUI()
            }
        }
    }
    
    // MARK: - Business
    
    func updateUI() {
        tableView.reloadData()
        updateWetherInfoView()
        
        cityLabel.text = shared.api.city.name
        
        if let currentWeather = shared.api.city.currentWeather  {
            tempLabel.text = currentWeather.stringValueForWeatherInfoType(.Temperature)
            weatherLabel.text = currentWeather.stringValueForWeatherInfoType(.Summary)
        } else {
            tempLabel.text = "--°"
            weatherLabel.text = ""
        }
    }
    
    func updateWetherInfoView() {
        
        for i in 0..<weatherInfoTitles.count {
            let type = weatherInfoTitles[i]
            let label = weatherInforView.titleLabelAtIndex(i)
            label.text = CurrentWeather.descriptionForWeatherInfoType(type)
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
}
