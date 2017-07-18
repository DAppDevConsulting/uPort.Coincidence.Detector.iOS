//
//  UIImageView+RoundCorners.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/18/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

extension UIImageView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
