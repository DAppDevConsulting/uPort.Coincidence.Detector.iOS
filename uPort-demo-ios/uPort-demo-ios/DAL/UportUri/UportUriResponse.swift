//
//  UportUriResponse.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UportUriResponse: BaseResponse {
    required init(response: DataResponse<Any>) {
        super.init(response: response)
        
        if let json = response.result.value {
            data = JSON(json) as AnyObject?
            //TODO: parse data
        }
    }
}
