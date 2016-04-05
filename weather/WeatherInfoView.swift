//
//  WeatherInfoView.swift
//  weather
//
//  Created by Baldoph Pourprix on 30/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit
import WeatherKit
import RxSwift
import RxCocoa

class WeatherInfoView: UIView {
    
    private var weatherInfoTitles: [WeatherInfoType] = [.Sunrise, .Sunset, .Clouds, .Rain, .Humidity, .Pressure]
    
    private var dateFormatter: NSDateFormatter = {
        var df = NSDateFormatter()
        df.timeStyle = .ShortStyle
        return df
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearAllValues()
    }
    
    var currentWeather: CurrentWeather? {
        didSet {
            
            /* left labels: titles */
            for i in 0..<weatherInfoTitles.count {
                let type = weatherInfoTitles[i]
                let label = titleLabelAtIndex(i)
                label.text = CurrentWeather.descriptionForWeatherInfoType(type) + ":"
            }
            
            if let currentWeather = currentWeather {
                /* right labels : values */
                    for i in 0..<weatherInfoTitles.count {
                        let type = weatherInfoTitles[i]
                        let label = valueLabelAtIndex(i)
                        label.text = currentWeather.stringValueForWeatherInfoType(type)
                    }
            } else {
                clearAllValues()
            }
        }
    }
    
    var rx_currentWeather: AnyObserver<CurrentWeather?> {
        return UIBindingObserver(UIElement: self) { view, weather in
            view.currentWeather = weather
            }.asObserver()
    }
    
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var valueLabels: [UILabel]!
    
    func titleLabelAtIndex(index: Int) -> UILabel {
        return titleLabels.filter { $0.tag == index }[0]
    }
    
    func valueLabelAtIndex(index: Int) -> UILabel {
        return valueLabels.filter { $0.tag == index }[0]
    }
    
    func clearAllValues() {
        for lbl in valueLabels {
            lbl.text = nil
        }
    }
}
