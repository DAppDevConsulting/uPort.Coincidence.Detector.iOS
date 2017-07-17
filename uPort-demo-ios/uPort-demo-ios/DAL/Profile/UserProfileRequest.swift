//
//  UserProfileRequest.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import Alamofire

class UserProfileRequest: IRequest {
    
    var requestId = ""
    
    func method() -> HTTPMethod {
        return .get
    }
    
    func url() -> String {
        return "/profile"
    }
    
    func type() -> RequestType {
        return .profile
    }
    
    func params() -> [String : AnyObject]? {
        return ["requestId": requestId as AnyObject]
    }
    
    func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }

}
