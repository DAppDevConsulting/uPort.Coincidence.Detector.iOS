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

    func openCustomApp(with URLScheme: String) {
        if let customUrl = URL(string:URLScheme) {
            if appDelegate.canOpenURL(customUrl) {
                if openCustomURLScheme(customURLScheme: URLScheme) {
                    print("app was opened successfully")
                }
            } else {
                openAttensionView()
            }
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
    
    private func openAttensionView() {
        let window = UIApplication.shared.keyWindow
        if let topController = window?.rootViewController {
            if let popupVC = UIStoryboard.main().instantiateViewController(withIdentifier: "AttensionPopupVC") as? AttensionPopup {
                popupVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                popupVC.modalTransitionStyle = .crossDissolve
                topController.present(popupVC, animated: true, completion: nil)
            }
        }
    }
}
