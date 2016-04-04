//
//  Fixturing.swift
//  SampleWLSwiftNetworking
//
//  Created by Antoine Gamond on 09/03/2016.
//  Copyright © 2016 Worldline. All rights reserved.
//

import Foundation

/**
 *  The protocol Fixturing must be used in the Service stub to handle the fixture
 */
public protocol Fixturing {

    init()
    mutating func handleFixture(fixture: Fixture)
}
