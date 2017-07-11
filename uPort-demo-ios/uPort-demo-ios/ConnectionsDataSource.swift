 //
//  ConnectionsDataSource.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/11/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

protocol ConnectionsDataSourceDelegate: class {
    func sourceDidReceiveNewData()
}

class ConnectionsDataSource: NSObject {
    fileprivate weak var delegate: ConnectionsDataSourceDelegate?
    fileprivate var connections = [String]()
    
    init(with callbackResponder: ConnectionsDataSourceDelegate) {
        super.init()
        delegate = callbackResponder
    }
    
    func append(_ array: [String]) {
        connections.append(contentsOf: array)
        delegate?.sourceDidReceiveNewData()
    }
    
    func remove(item: String) {
        if let index = connections.index(of: item) {
            connections.remove(at: index)
        }
        delegate?.sourceDidReceiveNewData()
    }
    
    func removeAll() {
        connections.removeAll()
        delegate?.sourceDidReceiveNewData()
    }
    
    func count() -> Int {
        return connections.count
    }
    
    func item(at index: Int) -> String {
        return connections[index]
    }
}

extension ConnectionsDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        cell.textLabel?.text = connections[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections.count
    }
}

