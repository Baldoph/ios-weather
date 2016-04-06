//
//  ClientTests.swift
//  weather
//
//  Created by Baldoph Pourprix on 05/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import XCTest
import Argo
import Curry
import Alamofire
import RxCocoa
import RxSwift
@testable import WeatherKit

class ClientTests: XCTestCase {
    
    func testRequestWithValidJSON() {
        let json = ["test": "text"]
        let result: Result<AnyObject, NSError> = Result.Success(json)
        let response = Alamofire.Response(request: nil, response: nil, data: nil, result: result)
        
        let client = StubClient(baseURL: "")
        client.responseJSON = response
        
        let network = NetworkTest(client: client, disposeBag: DisposeBag())
        
        let observable: Observable<DecodableTest> = network.request(.GET, urlPath: "", parameters: nil)
        
        var onNext: DecodableTest?
        var onError: NetworkError?
        var onCompleted = false
        
        observable.subscribe(
            onNext: { (response) -> Void in
                onNext = response
            },
            
            onError: { (error) -> Void in
                onError = error as? NetworkError
            },
            
            onCompleted: { () -> Void in
                onCompleted = true
        }).addDisposableTo(network.disposeBag)
        
        XCTAssertNotNil(onNext)
        XCTAssertNil(onError)
        XCTAssertFalse(onCompleted)
    }
    
    func testRequestWithInvalidJSON() {
        let json = ["dummy": "text"]
        let result: Result<AnyObject, NSError> = Result.Success(json)
        let response = Alamofire.Response(request: nil, response: nil, data: nil, result: result)
        
        let client = StubClient(baseURL: "")
        client.responseJSON = response
        
        let network = NetworkTest(client: client, disposeBag: DisposeBag())
        
        let observable: Observable<DecodableTest> = network.request(.GET, urlPath: "", parameters: nil)
        
        var onNext: DecodableTest?
        var onError: NetworkError?
        var onCompleted = false
        
        observable.subscribe(
            onNext: { (response) -> Void in
                onNext = response
            },
            
            onError: { (error) -> Void in
                onError = error as? NetworkError
            },
            
            onCompleted: { () -> Void in
                onCompleted = true
        }).addDisposableTo(network.disposeBag)
        
        XCTAssertNil(onNext)
        XCTAssertNotNil(onError)
        XCTAssertFalse(onCompleted)
    }
}

struct DecodableTest: Decodable {

    let text: String
    
    static func decode(json: JSON) -> Decoded<DecodableTest> {
        return curry(DecodableTest.init) <^> json <| "test"
    }
}

struct NetworkTest: Networking {
    var client: Client
    var disposeBag: DisposeBag
}
