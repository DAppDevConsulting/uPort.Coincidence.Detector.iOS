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
    
    @IBOutlet weak var connectionTypeTableView: UITableView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var selectedConnectionTypeLabel: UILabel!
    @IBOutlet weak var transitModeSwitch: UISwitch!
    @IBOutlet weak var receiveModeSwitch: UISwitch!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    lazy var dataSource: ConnectionsTypeDataSource = {
        let source = ConnectionsTypeDataSource(with: nil)
        return source
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setupTableView()
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.lookingForPeers()
    }

    func setupTableView() {
        dataSource.append([Texts.bumpTitle, Texts.handDanceTitle, Texts.imageRecognitionTitle])
        connectionTypeTableView.dataSource = dataSource
        connectionTypeTableView.delegate = self
        connectionTypeTableView.register(UITableViewCell.self, forCellReuseIdentifier: dataSource.tableViewCellID)
        let indexPath = IndexPath(item: 0, section: 0)
        connectionTypeTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        setConnectionTypeLabel(with: dataSource.item(at: 0))
    }
    
    func setConnectionTypeLabel(with text: String) {
        selectedConnectionTypeLabel.text = "\(Texts.byTitle) \(text)"
    }
    
    //MARK: - actions
    @IBAction func distanceSliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        distanceLabel.text = "\(value) \(Texts.measureTitle)"
    }
    @IBAction func startButtonClicked(_ sender: Any) {
        appDelegate.mpcManager.send(text: "Test string")
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
        guard let dataReceived = data["data"], let peerName = data["fromPeer"] else { return }
        ShowBaseAlertCommand().execute(with: "Data received \(dataReceived) from \(peerName)")
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setConnectionTypeLabel(with: dataSource.item(at: indexPath.row))
    }
}
