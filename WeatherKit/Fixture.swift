//
//  Fixture.swift
//  SampleWLSwiftNetworking
//
//  Created by Antoine Gamond on 09/03/2016.
//  Copyright © 2016 Worldline. All rights reserved.
//

import Foundation

/**
 *  The `FixtureGeneric` protocol must be conformed when writing a new `Fixture`. It features `OptionSetType`, is usable for `XCTest` and includes the non-generic `Fixture` protocol
 */
public protocol FixtureGeneric: OptionSetType, UITestsArgumentable, Fixture {

}

/**
 *  The empty `Fixture` Protocol is used in the `Fixturing` Protocol because it's not generic. (Unlike FixtureGeneric)
 */
public protocol Fixture {

}
