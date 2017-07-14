//
//  MainViewController.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/12/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreMotion

class MainViewController: UIViewController {
    
    @IBOutlet weak var connectionTypePickerView: UIPickerView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var selectedConnectionTypeLabel: UILabel!
    @IBOutlet weak var transitModeSwitch: UISwitch!
    @IBOutlet weak var receiveModeSwitch: UISwitch!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    lazy var pickerConfigurator: ConnectionsTypePickerConfigurator = {
        return ConnectionsTypePickerConfigurator(with: self)
    }()
    
    let motionManager = CDMotionManager()
    var currentConnectionType: ConnectionsDescriptor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        automaticallyAdjustsScrollViewInsets = false
        motionManager.delegate = self
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.lookingForPeers()
    }
    
    func setupPickerView() {
        pickerConfigurator.append(ConnectionsDescriptor.array)
        connectionTypePickerView.dataSource = pickerConfigurator
        connectionTypePickerView.delegate = pickerConfigurator
        connectionTypePickerView.selectRow(0, inComponent: 0, animated: true)
        currentConnectionType = pickerConfigurator.item(at: 0)
        setConnectionTypeLabel(with: currentConnectionType.title())
    }
    
    func setConnectionTypeLabel(with text: String?) {
        if let unwrappedText = text {
            selectedConnectionTypeLabel.text = "\(Texts.byTitle) \(unwrappedText)"
        }
    }
    
    //MARK: - actions
    func showConfirmationAlert(_ switchMode: UISwitch, message text: String) {
        if !switchMode.isOn {
            let alert = UIAlertController(title: "", message: text, preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction: UIAlertAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                switchMode.isOn = false
            }
            
            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                switchMode.isOn = true
            }
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func distanceSliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        distanceLabel.text = "\(value) \(Texts.measureTitle)"
    }
    
    @IBAction func recieveModeToggle(_ sender: UISwitch) {
        showConfirmationAlert(sender, message: "Are you sure you don't want to receive data?")
    }

    @IBAction func transmitModeToggle(_ sender: UISwitch) {
        showConfirmationAlert(sender, message: "Are you sure you don't want to transmit data?")
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        if currentConnectionType == .bump {
            motionManager.bump()
        }
    }
}

extension MainViewController: MPCManagerDelegate {

    func manager(_ manager: MPCManager, connectedWithPeer peerID: MCPeerID) {
        ShowBaseAlertCommand().execute(with: "Connected with \(peerID.displayName).")
    }

    func manager(_ manager: MPCManager, lostPeer peerID: MCPeerID) {
        ShowBaseAlertCommand().execute(with: "Lost \(peerID.displayName) peer.")
    }
    
    func manager(_ manager: MPCManager, dataReceive data: [String: String]) {
        if receiveModeSwitch.isOn {
            guard let dataReceived = data["data"], let peerName = data["fromPeer"] else { return }
            ShowBaseAlertCommand().execute(with: "Data received \(dataReceived) from \(peerName)")
        }
    }
}

extension MainViewController: ConnectionsTypePickerDelegate {
    func source(_ source: ConnectionsTypePickerConfigurator, didSelectRow row: Int) {
        currentConnectionType = pickerConfigurator.item(at: row)
        setConnectionTypeLabel(with: pickerConfigurator.item(at: row).title())
    }
}

extension MainViewController: CDMotionManagerDelegate {
    func manager(_ manager: CDMotionManager, bumpDetectedWith accelerometerData: CMAcceleration, andDateTime date: Date) {
        if transitModeSwitch.isOn {
            appDelegate.mpcManager.send(text: "TEST BUMP STRING at \(Date.convert(date))")
        }
    }
}
