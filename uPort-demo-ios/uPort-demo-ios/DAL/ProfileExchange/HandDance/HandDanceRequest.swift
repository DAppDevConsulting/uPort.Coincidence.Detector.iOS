//
//  HandDanceRequest.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/25/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import Alamofire

class HandDanceRequest: IRequest {
    
    private var gesture: String?
    var isTransmitModeOn = true
    
    init(gesture: String) {
        self.gesture = gesture
    }
    
    func method() -> HTTPMethod {
        return .post
    }
    
    func url() -> String {
        return "/profile-exchange/hand-dance"
    }
    
    func type() -> RequestType {
        return .profile
    }
    
    func params() -> [String : AnyObject]? {
        if isTransmitModeOn {
            let data = CDUserDefaults().buildUserInfoJSON()
            return ["profile":  data as AnyObject, "gesture": gesture as AnyObject]
        }
        return ["gesture": gesture as AnyObject]
    }
    
    func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
}
