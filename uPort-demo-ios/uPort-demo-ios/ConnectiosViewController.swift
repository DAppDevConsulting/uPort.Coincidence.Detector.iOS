//
//  ConnectiosViewController.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/10/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectiosViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var visibleSwitch: UISwitch!
    @IBOutlet weak var connectionsTableView: UITableView!
    @IBOutlet weak var disconnectButton: UIButton!
    
    var mcManager = MCManager()
    
    lazy var dataSource: ConnectionsDataSource = {
        let source = ConnectionsDataSource(with: self)
        return source
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        mcManager.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        connectionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        connectionsTableView.dataSource = dataSource
        mcManager.setupPeerAndSessionWithDisplayName(displayName: UIDevice.current.name)
        mcManager.advertise(shouldAdvertise: visibleSwitch.isOn)
    }

    //MARK: - actions
    @IBAction func browseForDevises(_ sender: Any) {
        mcManager.setupMCBrowser()
        mcManager.browser?.delegate = self
        if let browser = mcManager.browser {
            present(browser, animated: true, completion: nil)
        }
    }
    
    @IBAction func disconnect(_ sender: Any) {
        mcManager.session?.disconnect()
        nameTextField.isEnabled = true
        dataSource.removeAll()
    }
    
    @IBAction func toggleVisibility(_ sender: Any) {
        mcManager.advertise(shouldAdvertise: visibleSwitch.isOn)
    }
}

extension ConnectiosViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        if let browser = mcManager.browser {
            browser.dismiss(animated: true, completion: nil)
        }
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        if let browser = mcManager.browser {
            browser.dismiss(animated: true, completion: nil)
        }
    }
}

extension ConnectiosViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        mcManager.updateConnection()
        mcManager.setupPeerAndSessionWithDisplayName(displayName: nameTextField.text!)
        mcManager.setupMCBrowser()
        mcManager.advertise(shouldAdvertise: visibleSwitch.isOn)
        return true
    }
}

extension ConnectiosViewController: MCManagerDelegate {
    func connectedDevicesChanged(_ manager: MCManager, connectedDevices: [String : Any]) {
        
        let peerDisplayName = connectedDevices["peerName"] as! String
        let state = connectedDevices["state"] as! MCSessionState
        
        if state == MCSessionState.connected {
            dataSource.append([peerDisplayName])
        } else if state == MCSessionState.notConnected {
            dataSource.remove(item: peerDisplayName)
        }
    
    }
}

extension ConnectiosViewController: ConnectionsDataSourceDelegate {
    func sourceDidReceiveNewData() {
        connectionsTableView.reloadData()
        let peerExist = dataSource.count() == 0
        disconnectButton.isEnabled = !peerExist
        nameTextField.isEnabled = peerExist
    }
}
