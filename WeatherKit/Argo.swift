//
//  Argo.swift
//  weather
//
//  Created by Baldoph Pourprix on 04/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import Argo

let toNSDate: Int -> Decoded<NSDate> = {
    .fromOptional(NSDate(timeIntervalSince1970: NSTimeInterval($0)))
}

let toTemperature : Float -> Decoded<Temperature> = {
    .fromOptional(Temperature(value: $0))
}