//
//  Stubbing.swift
//  SampleWLSwiftNetworking
//
//  Created by Antoine Gamond on 26/02/2016.
//  Copyright © 2016 Worldline. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol Stubbing {

    func handleStub<T>(result: Result<T, NetworkError>?) -> Observable<T>
}

extension Stubbing {

    func handleStub<T>(result: Result<T, NetworkError>?) -> Observable<T> {

        return Observable<T>.create { observer in

            if let response = result {
                switch response {
                case .Success(let response):
                    observer.onNext(response)
                case .Failure(let error):
                    observer.onError(error)
                }
            } else {
                observer.onCompleted()
            }

            return NopDisposable.instance
        }
    }
}
