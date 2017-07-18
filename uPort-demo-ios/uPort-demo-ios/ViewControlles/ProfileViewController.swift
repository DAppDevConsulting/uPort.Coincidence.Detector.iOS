//
//  ProfileViewController.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/18/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileCountryLabel: UILabel!
    @IBOutlet weak var profilePhoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let userInfo = CDUserDefaults().getUserInfo()
        guard let imageUrl = userInfo.imageUrl else { return }
        profileImageView.downloadFrom(link: imageUrl)
        profileNameLabel.text = userInfo.name
        profilePhoneLabel.text = userInfo.phone
        profileCountryLabel.text = userInfo.country
    }
}
