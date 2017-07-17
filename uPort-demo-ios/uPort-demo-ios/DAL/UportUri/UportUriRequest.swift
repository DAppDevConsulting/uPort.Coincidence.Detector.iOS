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
        
        //Test random token
        let randomToken = String.random()
        CDUserDefaults().token = randomToken
        return "/uport-uri?requestId=\(randomToken)"
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
