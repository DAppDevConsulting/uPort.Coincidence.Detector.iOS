//
//  IParsable.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/18/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol IParsable {
    func parse(json: JSON)
}
