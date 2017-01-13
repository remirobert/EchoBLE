//
//  Peripheral.swift
//  EchoBLE
//
//  Created by Remi Robert on 08/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import CoreBluetooth

enum DeviceConnectState {
    case processing
    case connected
    case disconnected
    case failedToConnect
}

class Device {
    let peripheral: CBPeripheral
    let name: String?
    var UUID: String
    let RSSI: RSSIContainer
    var connectable = false
    let advertisementData: AdvertisementData
    var connectionState: DeviceConnectState = .disconnected
    weak var delegate: DeviceStateUpdateDelegate?

    init(peripheral: CBPeripheral, RSSI: String, advertisementDictionary: NSDictionary) {
        self.peripheral = peripheral
        self.RSSI = RSSIContainer()
        name = peripheral.name ?? "N/A"
        UUID = peripheral.identifier.uuidString
        if let isConnectable = advertisementDictionary[CBAdvertisementDataIsConnectable] as? NSNumber {
            connectable = isConnectable.boolValue
        }
        advertisementData = AdvertisementData(datas: advertisementDictionary)
        print("advertisment data : \(advertisementDictionary)")
    }
}
