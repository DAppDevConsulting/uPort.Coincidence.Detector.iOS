//
//  UportUriHandler.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/18/17.
//  Copyright © 2017 1. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol UportUriHandlerDelegate: class {
    func handler(_ uportHandler: UportUriHandler, didReceive result: UportInfo)
}

class UportUriHandler {
    
    private weak var delegate: UportUriHandlerDelegate?
    
    init(with callbackResponder: UportUriHandlerDelegate) {
        delegate = callbackResponder
    }
    
    func requestUportURi() {
        let request = UportUriRequest()
        Server.sharedInstance.sendRequest(request: request, responseHandler: { response in
            if let success = response?.isSuccess {
                if success {
                    if let json = response?.data as? JSON {
                        let uportInfo = UportInfo()
                        uportInfo.parse(json: json)
                        self.delegate?.handler(self, didReceive: uportInfo)
                    }
                }
            }
        })
    }

}
