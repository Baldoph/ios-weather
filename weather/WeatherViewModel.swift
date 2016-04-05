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
    var currentTemperatureDescription = Variable<String>("--°")
    var currentWeatherDescription = Variable<String>("")
    
    init(service: WeatherService) {
        self.service = service
        
        // Reload data when app enters foreground
        NSNotificationCenter.defaultCenter().rx_notification(UIApplicationWillEnterForegroundNotification).subscribe { _ in
            self.updateWeatherForCityName(self.cityName.value)
            }.addDisposableTo(disposeBag)
    }
    
    /// We make two requests, one after the other to retrieve 1) Current weather and 2) Forecast on 8 days
    func updateWeatherForCityName(name: String) {
        
        let errorClosure = {
            self.setBlankValues()
        }
    
        service.requestCurrentForCity(name).subscribe { (event) in
            
            if let weatherResponse = event.element {
                
                self.handleResponseCurrentWeather(weatherResponse)
                
                self.service.requestForcastForCity(name).subscribe({ (event) in
                    
                    if let forecastResponse = event.element {
                        
                        self.handleResponseForcast(forecastResponse)
                        
                    } else { // error
                        
                        errorClosure()
                        
                    }
                }).addDisposableTo(self.disposeBag)
                
            } else { // error
                
                errorClosure()
            }
            
        }.addDisposableTo(disposeBag)
    }
    
    func setBlankValues() {
        self.forecasts.value = []
        self.cityName.value = ""
        self.currentWeather.value = nil
        self.currentTemperatureDescription.value = "--°"
        self.currentWeatherDescription.value = ""
    }
    
    func handleResponseCurrentWeather(currentWeatherResponse: CurrentWeatherResponse) {
        self.currentWeather.value = currentWeatherResponse.currentWeather
        self.currentTemperatureDescription.value = currentWeatherResponse.currentWeather.temperature.toString() + "°"
        self.currentWeatherDescription.value = currentWeatherResponse.currentWeather.weatherDescription[0].description.capitalizedString
    }
    
    func handleResponseForcast(forecastResponse: ForecastResponse) {
        self.forecasts.value = forecastResponse.forecats
        self.cityName.value = forecastResponse.city.name
    }
}

extension WeatherViewModel {
    
    func didBind() {
        updateWeatherForCityName("Lyon")
    }
}

extension WeatherViewModel {
    static func largeTemperaturePlacholder() -> String { return "--" }
    static func temperaturePlacholder() -> String { return "-" }
    static func copyPlacholder() -> String { return "-" }
}
