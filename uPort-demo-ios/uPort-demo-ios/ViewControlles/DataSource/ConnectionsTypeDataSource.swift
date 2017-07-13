//
//  ConnectionsTypeDataSource.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/12/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

protocol ConnectionsDataSourceDelegate: class {
    func source( _ source: ConnectionsTypeDataSource, didRecieveNew data: [ConnectionsDescriptor])
}

class ConnectionsTypeDataSource: NSObject {
    let tableViewCellID = "DefaultCell"
    fileprivate weak var delegate: ConnectionsDataSourceDelegate?
    fileprivate var connections = [ConnectionsDescriptor]()
    
    init(with callbackResponder: ConnectionsDataSourceDelegate?) {
        super.init()
        delegate = callbackResponder
    }
    
    func append(_ array: [ConnectionsDescriptor]) {
        connections.append(contentsOf: array)
        delegate?.source(self, didRecieveNew: connections)
    }
    
    func remove(item: ConnectionsDescriptor) {
        if let index = connections.index(of: item) {
            connections.remove(at: index)
        }
        delegate?.source(self, didRecieveNew: connections)
    }
    
    func removeAll() {
        connections.removeAll()
        delegate?.source(self, didRecieveNew: connections)
    }
    
    func count() -> Int {
        return connections.count
    }
    
    func item(at index: Int) -> ConnectionsDescriptor {
        return connections[index]
    }
}

extension ConnectionsTypeDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath)
        cell.textLabel?.text = connections[indexPath.row].title()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections.count
    }
}
