//
//  CDMotionManager.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/13/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import CoreMotion
protocol CDMotionManagerDelegate {
    func manager(_ manager: CDMotionManager, bumpDetectedWith  accelerometerData: CMAcceleration, andDateTime date: Date)
}

class CDMotionManager: NSObject {
    var delegate: CDMotionManagerDelegate?
    let manager = CMMotionManager()
    
    func bump() {
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.02
            manager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in
                if let x = data?.userAcceleration.x,
                    x < -2.5 {
                    guard let unwrappedSelf = self, let accelerometrUnwrappedData = data?.userAcceleration else { return }
                    self?.delegate?.manager(unwrappedSelf, bumpDetectedWith: accelerometrUnwrappedData, andDateTime: Date())
                    self?.manager.stopDeviceMotionUpdates()
                }
            }
        }
    }
}
