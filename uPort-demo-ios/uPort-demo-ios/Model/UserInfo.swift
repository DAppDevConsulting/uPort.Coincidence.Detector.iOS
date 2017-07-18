//
//  UserInfo.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/18/17.
//  Copyright © 2017 1. All rights reserved.
//

import Foundation
import SwiftyJSON

fileprivate struct JSONKeys {
    static let name = "name"
    static let phone = "phone"
    static let country = "country"
    static let image = "image"
    static let url = "url"
}

class UserInfo: IParsable {
    var name: String?
    var phone: String?
    var country: String?
    var imageUrl: String?
    
    func parse(json: JSON) {
        if !json.isEmpty {
            name = json[JSONKeys.name].string
            phone = json[JSONKeys.phone].string
            country = json[JSONKeys.country].string
            let imageJSON = json[JSONKeys.image]
            imageUrl = imageJSON[JSONKeys.url].string
        }
    }
}
