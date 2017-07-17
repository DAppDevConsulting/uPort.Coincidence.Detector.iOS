//
//  Reachabiliy.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import Foundation
import SystemConfiguration

struct ReachabilityConstants {
    static let Url: String = "http://google.com/"
    static let HttpMethod: String = "HEAD"
    static let SuccessSCode = 200
    static let TimeoutInterval = 10.0
}

public class Reachability {
    
    class func isConnectedToNetwork(completion: @escaping (Bool) -> Void) {
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: NSURL(string: ReachabilityConstants.Url)! as URL)
        request.httpMethod = ReachabilityConstants.HttpMethod
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = ReachabilityConstants.TimeoutInterval
        session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == ReachabilityConstants.SuccessSCode {
                    completion(true)
                }
            }else {
                completion(false)
            }
        }).resume()
    }
}

