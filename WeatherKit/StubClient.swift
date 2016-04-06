//
//  StubClient.swift
//  weather
//
//  Created by Baldoph Pourprix on 05/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import ReachabilitySwift
import Alamofire

public class StubClient: Client {
    public var baseURL: String
    public var reachability: Reachability?
    public var responseJSON: Alamofire.Response<AnyObject, NSError>?
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func requestJSON(method: Alamofire.Method, url: String, parameters: [String : AnyObject]?, headers: [String : String]?, completionHandler: Alamofire.Response<AnyObject, NSError> -> Void) {
        if let response = responseJSON {
            completionHandler(response)
        }
    }
}