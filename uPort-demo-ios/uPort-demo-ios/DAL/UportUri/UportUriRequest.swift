//
//  UportUriRequest.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import Alamofire

class UportUriRequest: IRequest {
    
    func method() -> HTTPMethod {
        return .get
    }
    
    func url() -> String {
        return "/uport-uri"
    }
    
    func type() -> RequestType {
        return .uportUri
    }
    
    func params() -> [String : AnyObject]? {
        return nil
    }
    
    func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
}
