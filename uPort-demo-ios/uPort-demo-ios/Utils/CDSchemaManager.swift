//
//  CDSchemaManager.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

class CDSchemaManager: NSObject {
    
    let appDelegate = UIApplication.shared

    //TODO: remove print results, handle results
    func openCustomApp(with URLScheme: String) {
        if let customUrl = URL(string:URLScheme) {
            if appDelegate.canOpenURL(customUrl) {
                print("true")
            }
        }
        if openCustomURLScheme(customURLScheme: URLScheme) {
            print("app was opened successfully")
        } else {
            print("unable to open")
        }
    }
    
    private func openCustomURLScheme(customURLScheme: String) -> Bool {
        if let customURL = URL(string: customURLScheme) {
            if appDelegate.canOpenURL(customURL) {
                if #available(iOS 10.0, *) {
                    appDelegate.open(customURL)
                } else {
                    appDelegate.openURL(customURL)
                }
                return true
            }
        }
        return false
    }

}
