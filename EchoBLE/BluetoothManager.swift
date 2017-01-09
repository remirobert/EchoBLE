//
//  BluetoothManager.swift
//  EchoBLE
//
//  Created by Remi Robert on 08/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol BluetoothManagerDelegate: class {
    func didUpdateScan()
}

final class BluetoothManager: NSObject {

    var manager: CBCentralManager!
    static let shared = BluetoothManager()

    var isEnabled = false
    var visiblePeripheralUUIDs = NSMutableOrderedSet()
    var visiblePeripherals = [String: Peripheral]()

    weak var delegate: BluetoothManagerDelegate?

    override init() {
        super.init()
        let options = [CBCentralManagerOptionShowPowerAlertKey: true]
        manager = CBCentralManager(delegate: self, queue: nil, options: options)
    }

    func startScanning() {
        visiblePeripheralUUIDs.removeAllObjects()
        visiblePeripherals.removeAll()
        manager.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning() {
        manager.stopScan()
    }
}

extension BluetoothManager: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            isEnabled = false
        case .poweredOn:
            isEnabled = true
            startScanning()
        case .resetting:
            isEnabled = false
        case .unauthorized:
            isEnabled = false
        case .unsupported:
            isEnabled = false
        case .unknown:
            isEnabled = false
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Peripheral found with name: \(peripheral.name)\nUUID: \(peripheral.identifier.uuidString)\nRSSI: \(RSSI)\nAdvertisement Data: \(advertisementData)")
        visiblePeripheralUUIDs.add(peripheral.identifier.uuidString)
        visiblePeripherals[peripheral.identifier.uuidString] = Peripheral(peripheral: peripheral, RSSI: RSSI.stringValue, advertisementDictionary: advertisementData as NSDictionary)
        self.delegate?.didUpdateScan()
    }
}
