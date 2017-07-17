//
//  IResponse.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import Alamofire

let SuccessResponseCode = 200

protocol IResponse {
    
    init(response: DataResponse<Any>)
    
    func isErrorUnspecified() -> Bool
    
    var isSuccess: Bool { get set }
    var data: AnyObject? { get }
    
    var error:Dictionary<String, String>? { get set }
    
}
