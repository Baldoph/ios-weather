//
//  weatherTests.swift
//  weatherTests
//
//  Created by Baldoph Pourprix on 29/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import XCTest
@testable import weather

class weatherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApiURL() {
        let api = WeatherAPI(key: "acf4afa1abdb42982de642934f090ad5")
        let url = api._urlForMethod(.Current)
        let expectedURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather")
        XCTAssert(url == expectedURL)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
