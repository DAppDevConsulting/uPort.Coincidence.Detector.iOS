//
//  ConnectionsTypePickerConfigurator.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/12/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

protocol ConnectionsTypePickerDelegate: class {
    func source(_ source: ConnectionsTypePickerConfigurator, didSelectRow row: Int)
}

class ConnectionsTypePickerConfigurator: NSObject {

    fileprivate weak var delegate: ConnectionsTypePickerDelegate?
    fileprivate var connections = [ConnectionsDescriptor]()
    
    init(with callbackResponder: ConnectionsTypePickerDelegate?) {
        super.init()
        delegate = callbackResponder
    }
    
    func append(_ array: [ConnectionsDescriptor]) {
        connections.append(contentsOf: array)
    }
    
    func remove(item: ConnectionsDescriptor) {
        if let index = connections.index(of: item) {
            connections.remove(at: index)
        }
    }
    
    func removeAll() {
        connections.removeAll()
    }
    
    func count() -> Int {
        return connections.count
    }
    
    func item(at index: Int) -> ConnectionsDescriptor {
        return connections[index]
    }
}

extension ConnectionsTypePickerConfigurator: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return count()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension ConnectionsTypePickerConfigurator: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = connections[row].title()
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.source(self, didSelectRow: row)
    }
}
