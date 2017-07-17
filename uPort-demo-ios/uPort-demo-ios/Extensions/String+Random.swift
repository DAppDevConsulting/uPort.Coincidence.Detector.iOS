//
//  String+Random.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

extension String {
    
    static func random() -> String {
        return NSUUID().uuidString.replacingOccurrences(of: "-", with: ".")
    }
}
