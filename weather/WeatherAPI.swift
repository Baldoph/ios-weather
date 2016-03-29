//
//  WeatherAPI.swift
//  weather
//
//  Created by Baldoph Pourprix on 29/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit
import Alamofire

/// The refresh rate in second, set to 10 minutes, as per the API recommendations
private let WeatherAPIMinimuRefreshRate: Double = 600

/// The number of days to show in the forecast section
private let WeatherAPIForecastDayCount = 8

private let WeatherAPIHost = "api.openweathermap.org"
private let WeatherAPIPath = "/data/2.5"

enum WeatherAPIMethod: String {
    case Current = "weather"
    case Forecast = "forecast/daily"
}

/// Handles the calls to the http://openweathermap.org API and the parsing of the results
class WeatherAPI: NSObject {
    
    let key: String!
    let city = City()
    
    private let queue = NSOperationQueue()
    
    private var lastUpdateTimestamp: NSTimeInterval {
        get {
            return NSUserDefaults.standardUserDefaults().doubleForKey("WeatherAPILastRefreshDate")
        }
        set {
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setDouble(newValue, forKey: "WeatherAPILastRefreshDate")
            ud.synchronize()
        }
    }
    
    /// - parameters:
    ///   - key: the API key to use for the API calls. Get yours at http://openweathermap.org/appid.
    required init(key k: String) {
        key = k
        super.init()
        Alamofire.Manager.sharedInstance.startRequestsImmediately = false
        queue.maxConcurrentOperationCount = 1
    }
    
    func updateWeather(completion: (ErrorType?) -> ()) {

        let currentTime = NSDate().timeIntervalSince1970
        guard currentTime - lastUpdateTimestamp >= WeatherAPIMinimuRefreshRate else {
            return
        } // Last refresh was more than `WeatherAPIMinimumRefreshRate` seconds ago
 
        // Update `lastUpdateTimestamp` so that multiple call won't happen at the same time
        lastUpdateTimestamp = currentTime

        let internalCompletion = { (error: ErrorType?) -> () in
            if error != nil { // In case of error we reset `lastUpdateTimestamp` to allow for successive tries
                self.lastUpdateTimestamp = 0
                completion(error)
            } else { // we call completion block only when the queue is empty
                if self.queue.operationCount == 0 {
                    completion(nil)
                }
            }
        }

        _updateCurrentWeather(internalCompletion)
        _updateForecast(internalCompletion)
    }
    
    // MARK: - Private
    
    func _updateCurrentWeather(completion: (ErrorType?) -> ()) {
        let url = _urlForMethod(.Current)
        var parameters = _defaultParameters()
        parameters["id"] = city.cityID
        
        let request = Alamofire.request(.GET, url, parameters: parameters)
        
        let operation = NetworkOperation(request: request,
                                         completion: completion) { (JSON) in
                                            self.city.currentWeather = CurrentWeather(dictionary: JSON)
                                            print("Retrieved current weather")
        }
        queue.addOperation(operation)
    }
    
    func _updateForecast(completion: (ErrorType?) -> ()) {
        let url = _urlForMethod(.Forecast)
        var parameters = _defaultParameters()
        parameters["id"] = city.cityID
        parameters["cnt"] = "\(WeatherAPIForecastDayCount)"
        
        let request = Alamofire.request(.GET, url, parameters: parameters)
        
        let operation = NetworkOperation(request: request,
                                         completion: completion) { (JSON) in
                                            self.city.daysForecasts = DayForecast.objectsFromJSON(JSON)
                                            print("Retrieved forcast for the next \(self.city.daysForecasts.count) days")
        }
        queue.addOperation(operation)
    }
}

/// Builders
extension WeatherAPI {
    func _urlForMethod(method: WeatherAPIMethod) -> NSURL {
        let components = NSURLComponents()
        components.scheme = "http"
        components.host = WeatherAPIHost
        components.path = WeatherAPIPath + "/" + method.rawValue
        return components.URL!
    }
    
    func _defaultParameters() -> [String: String] {
        return [
            "APPID": key,
            "units": "metric"
        ]
    }
}
