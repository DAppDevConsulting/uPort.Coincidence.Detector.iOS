//
//  ConnectionsDescriptor.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/13/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

enum ConnectionsDescriptor: Int {
    case bump = 0, handDance, imageRecognition
    
    func title() -> String? {
        switch self {
        case .bump: return Texts.bumpTitle
        case .handDance: return Texts.handDanceTitle
        case .imageRecognition: return Texts.imageRecognitionTitle
        }
    }

    static var array: [ConnectionsDescriptor] {
        return [.bump, .handDance, .imageRecognition]
    }
}

