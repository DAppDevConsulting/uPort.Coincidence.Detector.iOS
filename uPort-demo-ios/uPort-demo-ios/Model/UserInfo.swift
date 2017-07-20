//
//  UserInfo.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/18/17.
//  Copyright © 2017 1. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserInfoJSONKeys {
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
            name = json[UserInfoJSONKeys.name].string
            phone = json[UserInfoJSONKeys.phone].string
            country = json[UserInfoJSONKeys.country].string
            let imageJSON = json[UserInfoJSONKeys.image]
            imageUrl = imageJSON[UserInfoJSONKeys.url].string
        }
    }
}
