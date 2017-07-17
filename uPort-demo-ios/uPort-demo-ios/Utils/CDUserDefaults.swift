//
//  CdUportUserDefaults.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

class CDUserDefaults: NSObject {
    
    let keyToken = "AccessToken"
    let keyFirstLaunch = "FirstLaunch"
    
    private func synchronize() {
        UserDefaults.standard.synchronize()
    }
    
    var isLaunchedBefore: Bool {
        get {
            return (UserDefaults.standard.bool(forKey: keyFirstLaunch))
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: keyFirstLaunch)
            synchronize()
        }
    }
    
    var token: String? {
        get {
            return UserDefaults.standard.value(forKey: keyToken) as? String
        }
        set (newToken) {
            UserDefaults.standard.setValue(newToken, forKey: keyToken)
            synchronize()
        }
    }
}
