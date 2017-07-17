//
//  IRequest.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import Alamofire

enum RequestType {
    case uportUri
}

protocol IRequest {
    
    func method() -> Alamofire.HTTPMethod
    
    func url() -> String
    
    func type() -> RequestType
    
    func params() -> [String: AnyObject]?
    
    func headers() -> [String: String]?
    
    func encoding() -> ParameterEncoding
}

extension IRequest {
    func headers() -> [String: String]? {
        return [
            "Accept": "application/json" ]
    }
}
