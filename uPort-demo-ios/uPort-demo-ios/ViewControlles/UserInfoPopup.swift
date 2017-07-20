//
//  UserInfoPopup.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/20/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

class UserInfoPopup: UIViewController {
    
    @IBOutlet weak var userInfoImageView: UIImageView!
    @IBOutlet weak var userInfoNameLabel: UILabel!
    @IBOutlet weak var userInfoCountryLabel: UILabel!
    @IBOutlet weak var userInfoPhoneLabel: UILabel!
    
    var userInfo: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        setupUI()
    }
    
    func setupUI() {
        if let imageUrl = userInfo?.imageUrl {
            userInfoImageView.downloadFrom(link: imageUrl)
        }
        userInfoNameLabel.text = userInfo?.name
        userInfoCountryLabel.text = userInfo?.phone
        userInfoPhoneLabel.text = userInfo?.country
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion:nil)
    }
}
