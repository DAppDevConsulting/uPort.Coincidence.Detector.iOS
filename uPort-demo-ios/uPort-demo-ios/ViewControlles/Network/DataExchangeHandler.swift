//
//  DataExchangeHandler.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/20/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol DataExchangeHandlerDelegate: class {
    func handler(_ uportHandler: DataExchangeHandler, didReceive result: [UserInfo])
    func handler(_ uportHandler: DataExchangeHandler, didReceiveFail result: Bool)
}

class DataExchangeHandler {
    
    private var spinnerProvider = SpinnerProvider()
    weak var delegate: DataExchangeHandlerDelegate?
    
    init(with callbackResponder: DataExchangeHandlerDelegate?) {
        delegate = callbackResponder
    }
    
    private func sendRequest(request: IRequest) {
        spinnerProvider.startSpinner()
        Server.sharedInstance.sendRequest(request: request, responseHandler: { response in
            self.spinnerProvider.stopSpinner()
            if let success = response?.isSuccess {
                if success {
                    if let json = response?.data as? JSON {
                        let profileJSONs = json["profiles"].arrayValue
                        var profiles = [UserInfo]()
                        for profileJSON in profileJSONs {
                            let userInfo = UserInfo()
                            userInfo.parse(json: profileJSON)
                            profiles.append(userInfo)
                        }
                        self.delegate?.handler(self, didReceive: profiles)
                    }
                } else {
                    self.delegate?.handler(self, didReceiveFail: true)
                }
            }
        })
    }
    
    func bumpRequest(isTransmitModeOn: Bool) {
        let request = BumpRequest()
        request.isTransmitModeOn = isTransmitModeOn
        sendRequest(request: request)
    }
    
    func handDanceRequest(isTransmitModeOn: Bool, andGesture gesture: String) {
        let request = HandDanceRequest(gesture: gesture)
        request.isTransmitModeOn = isTransmitModeOn
        sendRequest(request: request)
    }
}
