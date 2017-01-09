//
//  Peripheral.swift
//  EchoBLE
//
//  Created by Remi Robert on 08/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import CoreBluetooth

struct Peripheral {
    var peripheral: CBPeripheral
    var name: String?
    var UUID: String
    var RSSI: String
    var connectable = false

    init(peripheral: CBPeripheral, RSSI: String, advertisementDictionary: NSDictionary) {
        self.peripheral = peripheral
        name = peripheral.name ?? "No name."
        UUID = peripheral.identifier.uuidString
        self.RSSI = RSSI
        if let isConnectable = advertisementDictionary[CBAdvertisementDataIsConnectable] as? NSNumber {
            connectable = isConnectable.boolValue
        }
    }
}
