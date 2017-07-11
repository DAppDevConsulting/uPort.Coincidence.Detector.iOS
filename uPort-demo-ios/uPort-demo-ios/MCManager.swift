//
//  MCManager.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/11/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MCManagerDelegate {
    func connectedDevicesChanged(_ manager: MCManager, connectedDevices: [String : Any])
}


class MCManager: NSObject {
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let serviceType = "example-uport"
    
    var peerID: MCPeerID?
    var session: MCSession?
    var browser: MCBrowserViewController?
    var advertiser: MCAdvertiserAssistant?
    
    var delegate: MCManagerDelegate?
    
    override init() {
        super.init()
    }
    
    func updateConnection() {
        peerID = nil
        session = nil
        browser = nil
        advertiser?.stop()
        advertiser = nil
    }
    
    func setupPeerAndSessionWithDisplayName(displayName: String) {
        peerID = MCPeerID(displayName: displayName)
        if let peerIDUnwrapped = peerID {
            session = MCSession(peer: peerIDUnwrapped)
            session?.delegate = self
        }
    }
    
    func setupMCBrowser() {
        if let unwrappedSesion = session {
            browser = MCBrowserViewController(serviceType: serviceType, session: unwrappedSesion)
        }
    }
    
    func advertise(shouldAdvertise: Bool) {
        if shouldAdvertise {
            guard let unwrappedSesion = session else { return }
            advertiser = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: unwrappedSesion)
            advertiser?.start()
        } else {
            advertiser?.stop()
            advertiser = nil
        }
    }

}

extension MCManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        let devices = ["peerName": peerID.displayName, "state":state] as [String : Any]
        
        delegate?.connectedDevicesChanged(self, connectedDevices:devices)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)!
        NSLog("%@", "didReceiveDataString: \(str)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }

}
