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

struct MainConstants {
    static let UserInfoPopupId: String = "UserInfoPopupVC"
}

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
            
            let confirmAction: UIAlertAction = UIAlertAction(title: Texts.yesTitle, style: UIAlertActionStyle.default) { (alertAction) -> Void in
                switchMode.isOn = false
            }
            
            let cancelAction = UIAlertAction(title: Texts.noTitle, style: UIAlertActionStyle.default) { (alertAction) -> Void in
                switchMode.isOn = true
            }
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showUserInfoPopup(withUserInfo userInfo: UserInfo) {
        if let popupVC = UIStoryboard.main().instantiateViewController(withIdentifier: MainConstants.UserInfoPopupId) as? UserInfoPopup {
            popupVC.userInfo = userInfo
            popupVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            present(popupVC, animated: true, completion: nil)
        }
    }
    
    func bumpAction() {
        let alert = UIAlertController(title: "", message: Texts.bumpMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction: UIAlertAction = UIAlertAction(title: Texts.okTitle, style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.motionManager.bump()
        }
        
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func distanceSliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        distanceLabel.text = "\(value) \(Texts.measureTitle)"
    }
    
    @IBAction func recieveModeToggle(_ sender: UISwitch) {
        showConfirmationAlert(sender, message: Texts.receiveConfirmationMessage)
    }

    @IBAction func transmitModeToggle(_ sender: UISwitch) {
        showConfirmationAlert(sender, message: Texts.transmitConfirmationMessage)
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        if currentConnectionType == .bump {
            bumpAction()
        } else {
            guard let title = currentConnectionType.title() else { return }
            ShowBaseAlertCommand().execute(with: String.init(format: Texts.toDoMessage, title))
        }
    }
}

extension MainViewController: MPCManagerDelegate {

    func manager(_ manager: MPCManager, connectedWithPeer peerID: MCPeerID) {
        //TODO: check if need
        //let displayingText = String(format: Texts.connectedWithMessage, peerID.displayName)
       // ShowBaseAlertCommand().execute(with:displayingText)
    }

    func manager(_ manager: MPCManager, lostPeer peerID: MCPeerID) {
        //TODO: check if need
        //let displayingText = String(format: Texts.lostPeerMessage, peerID.displayName)
        //ShowBaseAlertCommand().execute(with: displayingText)
    }
    
    func manager(_ manager: MPCManager, dataReceive data: [String: String]) {
        if receiveModeSwitch.isOn {
            guard let dataReceived = data[MPCManagerConstants.DataKey], let peerName = data[MPCManagerConstants.FromPeerKey] else { return }
            let displayingText = String(format: Texts.dataReceiveMessage, dataReceived, peerName)
            ShowBaseAlertCommand().execute(with: displayingText)
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
            let dataExchangeHandler = DataExchangeHandler(with: self)
            dataExchangeHandler.bumpRequest()
        }
    }
}

extension MainViewController: DataExchangeHandlerDelegate {
    func handler(_ uportHandler: DataExchangeHandler, didReceiveFail result: Bool) {
        ShowBaseAlertCommand().execute(with: Texts.unspecifiedServerErrorTitle)
    }
    
    func handler(_ uportHandler: DataExchangeHandler, didReceive result: [UserInfo]) {
         if receiveModeSwitch.isOn {
            if result.count > 0 {
                showUserInfoPopup(withUserInfo: result[0])
            } else {
                ShowBaseAlertCommand().execute(with: Texts.noBumpMessage)
            }
        }
    }
}
