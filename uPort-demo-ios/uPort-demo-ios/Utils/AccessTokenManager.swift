//
//  AccessTokenManager.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

class AccessTokenManager {
    
    static let sharedManager = AccessTokenManager()
    private init() {}
    
    func token() -> String? {
        return CDUserDefaults().token
    }
    
    func updateTokenWith(newToken: String?) {
        CDUserDefaults().token = newToken
    }
}

