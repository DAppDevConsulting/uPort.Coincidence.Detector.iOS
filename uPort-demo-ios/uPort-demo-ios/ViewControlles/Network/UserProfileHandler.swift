//
//  UserProfileHandler.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/18/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol UserProfileHandlerDelegate: class {
    func handler(_ uportHandler: UserProfileHandler, didReceive result: UserInfo)
}

class UserProfileHandler {
    
    private weak var delegate: UserProfileHandlerDelegate?
    
    init(with callbackResponder: UserProfileHandlerDelegate) {
        delegate = callbackResponder
    }
    
    func requestUserInfo(with profileLocation: String) {
        let request = UserProfileRequest()
        request.profileLocation = profileLocation
        Server.sharedInstance.sendRequest(request: request, responseHandler: { response in
            if let success = response?.isSuccess {
                if success {
                    if let json = response?.data as? JSON {
                        let userInfo = UserInfo()
                        userInfo.parse(json: json)
                        self.delegate?.handler(self, didReceive: userInfo)
                    }
                }
            }
        })
    }

}
