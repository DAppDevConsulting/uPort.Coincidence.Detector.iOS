//
//  UportInfo.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/18/17.
//  Copyright © 2017 1. All rights reserved.
//

import Foundation
import SwiftyJSON

fileprivate struct JSONKeys {
    static let uri = "uri"
    static let profileLocation = "profileLocation"
}

class UportInfo: IParsable {
    
    var uri: String?
    var profileLocation: String?
    
    func parse(json: JSON) {
        if !json.isEmpty {
            uri = json[JSONKeys.uri].string
            profileLocation = json[JSONKeys.profileLocation].string
        }
    }
}
