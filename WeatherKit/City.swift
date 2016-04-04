//
//  City.swift
//  weather
//
//  Created by Baldoph Pourprix on 01/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import Argo
import Curry

public struct City {
    public let name: String
    public let cityID: String
}

extension City: Decodable {
    public static func decode(j: JSON) -> Decoded<City> {
        return curry(City.init) <^> j <| "name" <*> j <| "name"
    }
}

