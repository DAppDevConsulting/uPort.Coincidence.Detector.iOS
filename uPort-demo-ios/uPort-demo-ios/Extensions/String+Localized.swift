//
//  String+Localized.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/12/17.
//  Copyright © 2017 1. All rights reserved.
//

import Foundation

extension String {
    public static func localized(key: String, comment: String) -> String {
        return NSLocalizedString(key, comment: comment)
    }
}
