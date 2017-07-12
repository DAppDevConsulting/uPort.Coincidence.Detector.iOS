//
//  SimpleBumpViewController.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/11/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import CoreMotion

class SimpleBumpViewController: UIViewController {
    
    @IBOutlet weak var connectionsLabel: UILabel!
    
    let colorService = SimpleMCManager()
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorService.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        colorService.lookingForPeers()
    }

    
    @IBAction func redTapped() {
        self.change(color: .red)
        colorService.send(colorName: "red")
    }
    
    @IBAction func yellowTapped() {
        self.change(color: .yellow)
        colorService.send(colorName: "yellow")
    }
    
    func change(color : UIColor) {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = color
        }
    }
}

extension SimpleBumpViewController : SimpleMCManagerDelegate {
    
    func connectedDevicesChanged(manager: SimpleMCManager, connectedDevices: [String]) {
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in
                if let x = data?.userAcceleration.x {                
                    if x < -2 {
                        self?.yellowTapped()
                    //self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }
    
    func colorChanged(manager: SimpleMCManager, colorString: String) {
        OperationQueue.main.addOperation {
            switch colorString {
            case "red":
                self.change(color: .red)
            case "yellow":
                self.change(color: .yellow)
            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }
    
}
