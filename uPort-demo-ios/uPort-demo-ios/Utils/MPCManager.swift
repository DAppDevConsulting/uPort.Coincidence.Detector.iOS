//
//  MCPManager.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/12/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MPCManagerDelegate {
    func manager(_ manager: MPCManager, lostPeer peerID: MCPeerID)
    func manager(_ manager: MPCManager, connectedWithPeer peerID: MCPeerID)
    func manager(_ manager: MPCManager, dataReceive data: [String: String])
}

class MPCManager: NSObject {
    
    var session: MCSession?
    var peer: MCPeerID?
    var browser: MCNearbyServiceBrowser?
    var advertiser: MCNearbyServiceAdvertiser?
    
    var delegate: MPCManagerDelegate?
    var foundPeers = [MCPeerID]()
    
    private let serviceType = "uport-demo"
    
    override init() {
        super.init()
        peer = MCPeerID(displayName: UIDevice.current.name)
        guard let unwrappedPeer = peer else { return }
        session = MCSession(peer: unwrappedPeer)
        session?.delegate = self
        browser = MCNearbyServiceBrowser(peer: unwrappedPeer, serviceType: serviceType)
        browser?.delegate = self
        advertiser = MCNearbyServiceAdvertiser(peer: unwrappedPeer, discoveryInfo: nil, serviceType: serviceType)
        advertiser?.delegate = self
    }
    
    func lookingForPeers() {
        browser?.startBrowsingForPeers()
        advertiser?.startAdvertisingPeer()
    }

    func send(text : String) {
        guard let connectedPeersCount = session?.connectedPeers.count, let connectedPeers = session?.connectedPeers else { return }
        NSLog("%@", "sendText: \(text) to \(connectedPeersCount) peers")
        
        if connectedPeersCount > 0 {
            do {
                try self.session?.send(text.data(using: .utf8)!, toPeers: connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        } else {
            ShowBaseAlertCommand().execute(with: "There are no connected peers")
        }
        
    }

}

extension MPCManager: MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case MCSessionState.connected:
                NSLog("%@", "Connected to session: \(session)")
                delegate?.manager(self, connectedWithPeer: peerID)
            case MCSessionState.connecting:
                NSLog("%@", "Connecting to session: \(session)")
            default:
                ShowBaseAlertCommand().execute(with: "Did not connect to session")
                NSLog("%@", "Did not connect to session: \(session)")
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let text = String(data: data, encoding: .utf8) else { return }
        let data = ["data": text, "fromPeer": peerID.displayName]
        self.delegate?.manager(self, dataReceive: data)
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

extension MPCManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, aPeer) in foundPeers.enumerated() {
            if aPeer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
        delegate?.manager(self, lostPeer: peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        foundPeers.append(peerID)
        browser.invitePeer(peerID, to: self.session!, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers with error: \(error.localizedDescription)")
    }
    
}

extension MPCManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
         NSLog("%@", "didNotStartAdvertisingPeer with error: \(error.localizedDescription)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
}
