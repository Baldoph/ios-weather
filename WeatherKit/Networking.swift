//
//  Networking.swift
//  SampleWLSwiftNetworking
//
//  Created by Antoine Gamond on 25/02/2016.
//  Copyright © 2016 Worldline. All rights reserved.
//

import Foundation
import Alamofire
import Argo
import RxSwift

public protocol Networking {
    var client: Client { get }

    var disposeBag: DisposeBag { get }

    func request<T: Decodable where T == T.DecodedType>(method: Alamofire.Method, urlPath: String, parameters: [String : AnyObject]?) -> Observable<T>
    
}

extension Networking {

    public func request<T: Decodable where T == T.DecodedType>(method: Alamofire.Method, urlPath: String, parameters: [String : AnyObject]?) -> Observable<T> {

        return self.requestDecodableJSON(method, url: client.urlWithPath(urlPath), parameters: client.allParameters(parameters), headers: client.headers)
    }

    private func requestDecodableJSON<T: Decodable where T == T.DecodedType>(method: Alamofire.Method, url: String, parameters: [String : AnyObject]?, headers: [String : String]?) -> Observable<T> {

        return Observable<T>.create { observer in

            self.requestJSON(method, url: url, parameters: parameters, headers: headers).subscribe({ (event) -> Void in
                switch event {
                case .Next(let json):

                    let decoded: Decoded<T> = decode(json)

                    switch decoded {
                    case .Success(let decodable):
                        observer.onNext(decodable)
                    case .Failure(let error):
                        observer.onError(NetworkError.JSONDecodeError(error: error))
                    }

                case .Error(let error):
                    observer.onError(error)
                case .Completed: break
                }
            }).addDisposableTo(self.disposeBag)

            return NopDisposable.instance
        }
    }

    private func requestJSON(method: Alamofire.Method, url: String, parameters: [String : AnyObject]?, headers: [String : String]?) -> Observable<AnyObject> {

        return Observable<AnyObject>.create { observer in

            self.client.requestJSON(method, url: url, parameters: parameters, headers: headers, completionHandler: { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    observer.onNext(value)
                case .Failure(let error):
                    observer.onError(NetworkError.NSURLError(error: error))
                }
                observer.onCompleted()
            })

            return NopDisposable.instance
        }
    }
}
