//
//  SwinjectStoryboard.swift
//  weather
//
//  Created by Baldoph Pourprix on 04/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import Swinject
import WeatherKit

extension SwinjectStoryboard {
    
    class func setup() {
        
        // Models
        defaultContainer.register(Client.self) { _ in WeatherClient() }
        defaultContainer.register(WeatherService.self) { r in WeatherNetwork(client: r.resolve(Client.self)!) }

        // View models
        defaultContainer.register(WeatherViewModel.self) { r in WeatherViewModel(service: r.resolve(WeatherService.self)!) }

        // Views
        defaultContainer.registerForStoryboard(WeatherViewController.self) { r, c in
            c.viewModel = r.resolve(WeatherViewModel.self)
        }
    }
}