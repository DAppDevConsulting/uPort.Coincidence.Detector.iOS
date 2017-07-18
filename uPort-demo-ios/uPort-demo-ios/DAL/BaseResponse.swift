//
//  BaseResponse.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct BaseResponseConstants {
    static let ErrorKey: String = "error"
    static let ErrorTitle: String = "Unspecified error"
}

class BaseResponse: NSObject, IResponse {
    
    var data: AnyObject?
    
    var isSuccess: Bool = true
    
    var error:Dictionary<String, String>?
    
    override init() {
        error = [String: String]()
    }
    
    required init(response: DataResponse<Any>) {
        super.init()
        
        if let json = response.result.value {
            data = JSON(json) as AnyObject?
        }
    }
    
    func handleUnspecifiedError() {
        ShowBaseAlertCommand().execute(with: Texts.unspecifiedServerErrorTitle)
        error![BaseResponseConstants.ErrorKey] = BaseResponseConstants.ErrorTitle
    }
    
    func isErrorUnspecified() -> Bool {
        if error![BaseResponseConstants.ErrorKey] == BaseResponseConstants.ErrorTitle {
            return true
        } else {
            return false
        }
    }
}

