//
//  Texts.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/12/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

class Texts: NSObject {

    class var bumpTitle: String {
        return String.localized(key: "BumpTitle", comment: "")
    }
    
    class var handDanceTitle: String {
        return String.localized(key: "HandTitle", comment: "")
    }
    
    class var imageRecognitionTitle: String {
        return String.localized(key: "ImageRecognitionTitle", comment: "")
    }
    
    class var byTitle: String {
        return String.localized(key: "ByTitle", comment: "")
    }
    
    class var okTitle: String {
        return String.localized(key: "OkTitle", comment: "")
    }
    
    class var measureTitle: String {
        return String.localized(key: "MeasureTitle", comment: "")
    }
}
