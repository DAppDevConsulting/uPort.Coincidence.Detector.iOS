//
//  ShowNoInternetConnectionAlertCommand.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

class ShowNoInternetConnectionAlertCommand: ICommand {
    func execute(with text: String) {
        let appDelegate = UIApplication.shared.delegate
        let alert = UIAlertController(title: Texts.noInternetConnection, message: text, preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction = UIAlertAction(title: Texts.okTitle, style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(acceptAction)
        guard let rootVC = appDelegate?.window??.rootViewController else { return }
        OperationQueue.main.addOperation { () -> Void in
            if (rootVC.presentedViewController != nil) {
                return
            }
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
}
