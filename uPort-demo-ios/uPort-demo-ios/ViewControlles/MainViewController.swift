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
    static let InfoPopupId: String = "InfoPopupVC"
    static let NotificationName: String = "UportData"
    static let NotificationUrlKey: String = "url"
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
    
    let motionrecognizer = MotionRecognizer.shared
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         NotificationCenter.default.addObserver(self, selector: #selector(handleUportData(_:)), name: Notification.Name(rawValue: MainConstants.NotificationName), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleUportData(_ notification: Notification) {
        if let url = notification.userInfo?[MainConstants.NotificationUrlKey] as? URL {
            let array = url.absoluteString.components(separatedBy: ":/")
            let profileLocation = array[1]
            let userInfoHanler = UserProfileHandler(with: self)
            userInfoHanler.requestUserInfo(with: profileLocation)
        }
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
    
    func showDrawTrianglePopup() {
        if let popupVC = UIStoryboard.main().instantiateViewController(withIdentifier: MainConstants.InfoPopupId) as? InfoPopup {
            popupVC.delegate = self
            popupVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            present(popupVC, animated: true, completion: nil)
        }
    }
    
    func askMeAlways(completion: @escaping (Bool) -> Void) {
        if CDUserDefaults().askMeAlways {
            let alert = UIAlertController(title: "", message: Texts.confirmAttestatinMessage, preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction: UIAlertAction = UIAlertAction(title: Texts.yesTitle, style: UIAlertActionStyle.default) { (alertAction) -> Void in
                completion(true)
            }
            
            let cancelAction: UIAlertAction = UIAlertAction(title: Texts.noTitle, style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)

        } else {
            completion(true)
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
        askMeAlways(completion: { [weak self] result in
            if result {
                if let connectionType = self?.currentConnectionType {
                    switch connectionType {
                    case .bump:
                        self?.bumpAction()
                    case .handDance:
                        self?.showDrawTrianglePopup()
                    default:
                        guard let title = connectionType.title() else { return }
                        ShowBaseAlertCommand().execute(with: String.init(format: Texts.toDoMessage, title))
                    }
                }
            }
        })
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
    
    func manager(_ manager: CDMotionManager, handDanceWith deviceMotionData: [CMDeviceMotion], andDateTime date: Date) {
        var drawnPoints = [StrokePoint]()
        for motion in deviceMotionData {
            let ass = motion.userAcceleration
            let strokePoint = StrokePoint(point: CGPoint(x: ass.x, y: ass.y))
            drawnPoints.append(strokePoint)
        }
        motionrecognizer.delegate = self
        motionrecognizer.createStrokeRecognizer(points: drawnPoints)

    }

    func manager(_ manager: CDMotionManager, bumpDetectedWith accelerometerData: CMAcceleration, andDateTime date: Date) {
        let dataExchangeHandler = DataExchangeHandler(with: self)
        dataExchangeHandler.bumpRequest(isTransmitModeOn: transitModeSwitch.isOn)
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

extension MainViewController: UserProfileHandlerDelegate {
    func handler(_ uportHandler: UserProfileHandler, didReceive result: UserInfo) {
        ShowBaseAlertCommand().execute(with: Texts.profileSavedMessage)
    }
}

extension MainViewController: MotionRecognizerDelegate {
    
    func recognizer(_ manager: MotionRecognizer, templateFoundWithName name: String) {
        let dataExchangeHandler = DataExchangeHandler(with: self)
        dataExchangeHandler.handDanceRequest(isTransmitModeOn: transitModeSwitch.isOn, andGesture: name)
    }
    
    func recognizer(_ manager: MotionRecognizer, templateNotFound text: String) {
        ShowBaseAlertCommand().execute(with: text)
    }
}

extension MainViewController: InfoPopupDelegate {
    func popup(_ popup: InfoPopup, buttonClicked clicked: Bool) {
        motionManager.handDance()
    }
}
