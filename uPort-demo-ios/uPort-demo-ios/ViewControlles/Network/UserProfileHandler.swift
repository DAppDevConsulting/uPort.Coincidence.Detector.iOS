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
    private var profileLocation: String!
    private var spinnerProvider = SpinnerProvider()
    
    init(with callbackResponder: UserProfileHandlerDelegate?) {
        delegate = callbackResponder
    }
    
    func requestUserInfo(with profileLocation: String) {
        spinnerProvider.startSpinner()
        let request = UserProfileRequest()
        self.profileLocation = profileLocation
        request.profileLocation = profileLocation
        Server.sharedInstance.sendRequest(request: request, responseHandler: { response in
            self.spinnerProvider.stopSpinner()
            if let success = response?.isSuccess {
                if success {
                    if let json = response?.data as? JSON {
                        let userInfo = UserInfo()
                        userInfo.parse(json: json)
                        let userDefaults = CDUserDefaults()
                        userDefaults.saveUserInfo(userInfo)
                        userDefaults.isLaunchedBefore = true
                        self.delegate?.handler(self, didReceive: userInfo)
                    }
                } else {
                    self.showFailAlert()
                }
            }
        })
    }
    
    private func showFailAlert() {
        let appDelegate = UIApplication.shared.delegate
        let failAlert = UIAlertController(title:Texts.failProfileTitle, message: Texts.failProfileMessage, preferredStyle: UIAlertControllerStyle.alert)
        failAlert.addAction(UIAlertAction(title: Texts.sendRequestTitle, style: .default, handler: { action in
            self.requestUserInfo(with: self.profileLocation)
        }))
        guard let rootVC = appDelegate?.window??.rootViewController else { return }
        rootVC.present(failAlert, animated: true, completion: nil)
    }
}
