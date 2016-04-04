//
//  WeatherViewModel.swift
//  weather
//
//  Created by Baldoph Pourprix on 04/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import WeatherKit
import RxSwift

struct WeatherViewModel {
    
    let service: WeatherService
    let disposeBag = DisposeBag()
    
    var cityName = Variable<String>("")
    var forecasts = Variable<[WeatherKit.DayForecast]>([])
    var currentWeather = Variable<WeatherKit.CurrentWeather?>(nil)
    
    init(service: WeatherService) {
        self.service = service
        
        // Reload data when app enters foreground
        NSNotificationCenter.defaultCenter().rx_notification(UIApplicationWillEnterForegroundNotification).subscribe { _ in
            self.updateWeatherForCityName(self.cityName.value)
            }.addDisposableTo(disposeBag)
    }
    
    func updateWeatherForCityName(name: String) {
        
        service.updateWeatherForCity(name).subscribe { (event) -> Void in
            
            if let (currentWeatherResponse, forecastResponse) = event.element {
                self.forecasts.value = forecastResponse.forecats
                self.cityName.value = forecastResponse.city.name
                self.currentWeather.value = currentWeatherResponse.currentWeather
            } else {
                
            }
        }.addDisposableTo(disposeBag)
    }
}

extension WeatherViewModel {
    
}
