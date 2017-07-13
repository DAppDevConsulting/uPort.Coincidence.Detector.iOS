//
//  Date+Convert.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/13/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

extension Date {
    
    static func convert(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}
