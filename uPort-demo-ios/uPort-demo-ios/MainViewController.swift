//
//  MainViewController.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/12/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MainViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.browser?.startBrowsingForPeers()
        appDelegate.mpcManager.advertiser?.startAdvertisingPeer()
    }

}

extension MainViewController: MPCManagerDelegate {

    func manager(_ manager: MPCManager, connectedWithPeer peerID: MCPeerID) {
        let alert = UIAlertController(title: "", message: "Connected with \(peerID.displayName)", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (alertAction) -> Void in
        }
        alert.addAction(acceptAction)
        self.present(alert, animated: true, completion: nil)

    }
    
    func manager(_ manager: MPCManager, invitationWasReceived fromPeer: String) {
    }
    
    func manager(_ manager: MPCManager, lostPeer peerID: MCPeerID) {
        let alert = UIAlertController(title: "", message: "\(peerID.displayName) lostPeer.", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            
                }
        alert.addAction(acceptAction)
        self.present(alert, animated: true, completion: nil)
    
    }
    
    func manager(_ manager: MPCManager, foundPeer peerID: MCPeerID) {
       
    }

}
