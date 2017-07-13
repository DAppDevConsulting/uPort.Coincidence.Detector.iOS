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
    func manager(_ manager: CDMotionManager, bumpDetectedWith  accelerometerData: CMAcceleration)
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
                    //TODO: - calculate date time
                    
                   /* let date = Date()
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date)
                    let minutes = calendar.component(.minute, from: date)*/
                    guard let unwrappedSelf = self, let accelerometrUnwrappedData = data?.userAcceleration else { return }
                    self?.delegate?.manager(unwrappedSelf, bumpDetectedWith: accelerometrUnwrappedData)
                    self?.manager.stopDeviceMotionUpdates()
                }
            }
        }
    }
}
