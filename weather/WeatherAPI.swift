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
    
    private var currentRequests: [Request] = []
    
    /// - parameters:
    ///   - key: the API key to use for the API calls. Get yours at http://openweathermap.org/appid.
    required init(key k: String) {
        key = k
        super.init()
        Alamofire.Manager.sharedInstance.startRequestsImmediately = false
    }
    
    func updateWeather(completion: (ErrorType?) -> ()) {
        
        let currentTime = NSDate().timeIntervalSince1970
        guard currentTime - lastUpdateTimestamp >= WeatherAPIMinimuRefreshRate else {
            return
        } // Last refresh was more than `WeatherAPIMinimumRefreshRate` seconds ago
        
        // Update `lastUpdateTimestamp` so that multiple call won't happen at the same time
        lastUpdateTimestamp = currentTime
        
        // In case of error we reset `lastUpdateTimestamp` to allow for successive tries
        let internalCompletion = { (error: ErrorType?) -> () in
            if error != nil {
                self.lastUpdateTimestamp = 0
            }
            completion(error)
        }

        currentRequests.append(_updateCurrentWeather(internalCompletion))
        currentRequests.append(_updateForecast(internalCompletion))
    }
    
    // MARK: - Private
    
    func _updateCurrentWeather(completion: (ErrorType?) -> ()) -> Request {
        let url = _urlForMethod(.Current)
        var parameters = _defaultParameters()
        parameters["id"] = city.cityID
        
        let request = Alamofire.request(.GET, url, parameters: parameters)
        _sendRequest(request, completion: completion) { (JSON) in
            self.city.currentWeather = CurrentWeather(dictionary: JSON)
            print("Retrieved current weather")
        }
        return request
    }
    
    func _updateForecast(completion: (ErrorType?) -> ())  -> Request {
        let url = _urlForMethod(.Forecast)
        var parameters = _defaultParameters()
        parameters["id"] = city.cityID
        parameters["cnt"] = "\(WeatherAPIForecastDayCount)"
        
        let request = Alamofire.request(.GET, url, parameters: parameters)
        _sendRequest(request, completion: completion) { (JSON) in
            self.city.daysForecasts = DayForecast.objectsFromJSON(JSON)
            print("Retrieved forcast for the next \(self.city.daysForecasts.count) days")
        }
        return request
    }
    
    /// Makes sure only the last request completed will call its completion block
    func _sendRequest(request: Request, completion: (ErrorType?) -> (), parser: (NSDictionary) -> ()) {
        request.responseJSON { response in
            dispatch_async(dispatch_get_main_queue(), {
                // Remove finished request from `currentRequests` array
                print("Comparing")
                let index = self.currentRequests.indexOf({ (aRequest) -> Bool in
                    // Two requests are equal if the following condition is met
                    print("\(aRequest.task.taskIdentifier) - \(request.task.taskIdentifier)")
                    return aRequest.task.taskIdentifier == request.task.taskIdentifier
                })! // Forcing unwrapping because `request` is the same object that is appended to `currentRequests` so we're bound to find an index
                self.currentRequests.removeAtIndex(index)
                
                switch response.result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    // Parse objects
                    let response = JSON as! NSDictionary
                    parser(response)

                    // Call completion block if needed
                    if self.currentRequests.count == 0 { // no more requests processing
                        completion(nil)
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    guard !(error.domain == NSURLErrorDomain && error.code != NSURLErrorCancelled) else {
                        // Request was cancelled
                        return
                    }
                    
                    // remove all current requests
                    for r in self.currentRequests {
                        r.cancel()
                    }
                    self.currentRequests = []
                    completion(error)
                }
            })
        }
        print("Resuming request: \(request.request?.URLString)")
        request.resume()
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
