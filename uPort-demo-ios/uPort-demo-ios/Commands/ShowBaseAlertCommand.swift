//
//  ShowBaseAlertCommand.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/12/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

class ShowBaseAlertCommand: ICommand {
    func execute(with text: String) {
        let appDelegate = UIApplication.shared.delegate
        let alert = UIAlertController(title: "", message: text, preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction = UIAlertAction(title: Texts.okTitle, style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(acceptAction)
        guard let rootVC = appDelegate?.window??.rootViewController else { return }
        rootVC.present(alert, animated: true, completion: nil)
    }
}
