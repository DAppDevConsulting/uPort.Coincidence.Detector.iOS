//
//  BumpRequest.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/20/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import Alamofire

class BumpRequest: IRequest {
    
    func method() -> HTTPMethod {
        return .post
    }
    
    func url() -> String {
        return "/profile-exchange/phone-bump"
    }
    
    func type() -> RequestType {
        return .profile
    }
    
    func params() -> [String : AnyObject]? {
        let data = CDUserDefaults().buildUserInfoJSON()
        return ["profile":  data as AnyObject]
    }
    
    func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
}
