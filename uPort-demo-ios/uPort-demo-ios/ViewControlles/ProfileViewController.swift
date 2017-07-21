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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let userInfo = CDUserDefaults().getUserInfo()
        if let imageUrl = userInfo.imageUrl {
            profileImageView.downloadFrom(link: imageUrl)
        }
        profileNameLabel.text = userInfo.name
        profilePhoneLabel.text = userInfo.phone
        profileCountryLabel.text = userInfo.country
    }
    
    //MARK: - actions
    @IBAction func resetIdentityButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: Texts.resetIdentityMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction: UIAlertAction = UIAlertAction(title: Texts.yesTitle, style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.navigationController?.popToRootViewController(animated: true)
            CDUserDefaults().isLaunchedBefore = false
            CDUserDefaults().clearUserInfo()
            self.appDelegate.uportUriHandler?.requestUportURi()
        }
        
        let cancelAction = UIAlertAction(title: Texts.noTitle, style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
