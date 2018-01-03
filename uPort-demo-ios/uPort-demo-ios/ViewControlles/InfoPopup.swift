//
//  InfoPopup.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/27/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

protocol InfoPopupDelegate: class {
    func popup(_ popup: InfoPopup, buttonClicked clicked: Bool)
}

class InfoPopup: UIViewController {

    weak var delegate: InfoPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.popup(self, buttonClicked: true)
    }
}
