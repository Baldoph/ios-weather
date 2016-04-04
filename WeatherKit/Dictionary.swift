//
//  Dictionary-Extension.swift
//  SampleWLSwiftNetworking
//
//  Created by Antoine Gamond on 22/02/2016.
//  Copyright © 2016 Worldline. All rights reserved.
//

import Foundation

extension Dictionary {

    /**
     Merge given dictionnary into existing one
     */
    mutating func merge<S: SequenceType where S.Generator.Element == (Key, Value) > (other: S?) {
        if let other = other {
            for (k, v) in other {
                self[k] = v
            }
        }
    }
}
