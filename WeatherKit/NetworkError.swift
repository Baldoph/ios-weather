//
//  NetworkError.swift
//  SampleWLSwiftNetworking
//
//  Created by Antoine Gamond on 26/02/2016.
//  Copyright © 2016 Worldline. All rights reserved.
//

import Foundation
import Argo

enum NetworkError: ErrorType {

    case NoResults
    case JSONDecodeError(error: DecodeError)
    case NSURLError(error: NSError)
}
