//
//  NetworkOperation.swift
//  weather
//
//  Created by Baldoph Pourprix on 29/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import Alamofire

class NetworkOperation : ConcurrentOperation {
    
    let completionHandler: (error: NSError?) -> ()
    let parser: (NSDictionary) -> ()
    let request: Request
    
    init(request: Request,
         completion: (error: NSError?) -> (),
         parser: (NSDictionary) -> ()) {
        self.request = request
        self.completionHandler = completion
        self.parser = parser
        super.init()
    }
    
    // when the operation actually starts, this is the method that will be called
    
    override func main() {
        request.responseJSON { response in
            self.completeOperation()
                switch response.result {
                case .Success(let JSON):
                    // Parse objects
                    let response = JSON as! NSDictionary
                    self.parser(response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.completionHandler(error: nil)
                    })
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    guard !(error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled) else {
                        // Request was cancelled
                        return
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.completionHandler(error: error)
                    })
                }
        }
        request.resume()
    }
    
    // we'll also support canceling the request, in case we need it
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
}