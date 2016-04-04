//
//  Client.swift
//  SampleWLSwiftNetworking
//
//  Created by Antoine Gamond on 23/02/2016.
//  Copyright © 2016 Worldline. All rights reserved.
//

import Foundation
import Alamofire

public protocol Client {

    var baseURL: String { get }
    var headers: [String : String]? { get }
    var baseParameters: [String: AnyObject]? { get }

    func requestJSON(method: Alamofire.Method, url: String, parameters: [String : AnyObject]?, headers: [String : String]?, completionHandler: Alamofire.Response<AnyObject, NSError> -> Void)
}

extension Client {

    public var headers: [String : String]? {
        return nil
    }

    public var baseParameters: [String : AnyObject]? {
        return nil
    }

    public func requestJSON(method: Alamofire.Method, url: String, parameters: [String : AnyObject]?, headers: [String : String]?, completionHandler: Alamofire.Response<AnyObject, NSError> -> Void) {

        Alamofire.request(method, url, parameters: parameters, headers: headers).responseJSON(completionHandler: { (response) -> Void in
            completionHandler(response)
        })
    }

    func urlWithPath(path: String) -> String {

        var url = baseURL

        if url.characters.last == "/" {
            url = String(url.characters.dropLast())
        }

        if path.characters.first == "/" {
            url += path
        } else {
            url += "/" + path
        }

        return url
    }

    func allParameters(parameters: [String : AnyObject]?) -> [String : AnyObject]? {

        guard baseParameters != nil || parameters != nil else { return nil }

        var allParameters = [String : AnyObject]()
        allParameters.merge(baseParameters)
        allParameters.merge(parameters)

        return allParameters
    }
}
