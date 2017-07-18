//
//  SettingsViewController.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/18/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

struct SettingsConstants {
    static let ProfileId: String = "ProfileVC"
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = CDUserDefaults().userName
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(openProfileVC))
        profileView.addGestureRecognizer(tapGesture)
    }
    
    func openProfileVC(){
        if let profileVC = UIStoryboard.main().instantiateViewController(withIdentifier: SettingsConstants.ProfileId) as? ProfileViewController {
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}
