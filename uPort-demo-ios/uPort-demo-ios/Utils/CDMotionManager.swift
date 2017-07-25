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
    func manager(_ manager: CDMotionManager, handDanceWith  deviceMotionData: [CMDeviceMotion], andDateTime date: Date)
}

struct CDMotionManagerConstants {
    static let UpdateDeviceDataIntervl: Double = 0.02
    static let MinBumpAcceleration: Double = 1.0
    static let HandDanceTimeout: Double = 2.0
}

class CDMotionManager: NSObject {
    var delegate: CDMotionManagerDelegate?
    let manager = CMMotionManager()
    
    func bump() {
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = CDMotionManagerConstants.UpdateDeviceDataIntervl
            manager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in
                if let x = data?.userAcceleration.x,
                    x > CDMotionManagerConstants.MinBumpAcceleration {
                    self?.manager.stopDeviceMotionUpdates()
                    guard let unwrappedSelf = self, let accelerometrUnwrappedData = data?.userAcceleration else { return }
                    self?.delegate?.manager(unwrappedSelf, bumpDetectedWith: accelerometrUnwrappedData, andDateTime: Date())
                }
            }
        }
    }
    
    func handDance() {
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = CDMotionManagerConstants.UpdateDeviceDataIntervl
            var motions = [CMDeviceMotion]()
            manager.startDeviceMotionUpdates(to: .main) { (data: CMDeviceMotion?, error: Error?) in
                if let data = data {
                    motions.append(data)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + CDMotionManagerConstants.HandDanceTimeout) { [weak self] in
                guard let unwrappedSelf = self else { return }
                unwrappedSelf.manager.stopDeviceMotionUpdates()
                unwrappedSelf.delegate?.manager(unwrappedSelf, handDanceWith: motions, andDateTime: Date())
            }
        }
    }
}
