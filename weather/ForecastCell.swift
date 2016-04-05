//
//  ForecastCell.swift
//  weather
//
//  Created by Baldoph Pourprix on 30/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit
import WeatherKit
import SwiftDate

private let weekdayFormatter: NSDateFormatter = {
    var df = NSDateFormatter()
    df.dateFormat = "EEEE"
    return df
}()

class ForecastCell: UITableViewCell {

    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    var forecast: DayForecast? {
        didSet {
            if let forecast = forecast {
                dayLabel.text = weekdayFormatter.stringFromDate(forecast.date)
                maxTempLabel.text = forecast.temperatureMax.toString()
                minTempLabel.text = forecast.temperatureMin.toString()
                today = forecast.date.isInToday()
            } else {
                dayLabel.text = ""
                maxTempLabel.text = "-"
                minTempLabel.text = "-"
                today = false
            }
        }
    }
    
    private var allLabels: [UILabel] {
        return [maxTempLabel, minTempLabel, dayLabel]
    }
    
    var today: Bool = false {
        didSet {
            if oldValue == today {
                return
            }
            for label in allLabels {
                if today {
                    label.font = UIFont.boldSystemFontOfSize(label.font.pointSize)
                } else {
                    label.font = UIFont.systemFontOfSize(label.font.pointSize)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }
}
