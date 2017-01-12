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
    private let queue = DispatchQueue(label: "com.queue.central.echoble", qos: DispatchQoS.background)
    static let shared = BluetoothManager()

    var isEnabled = false
    var visiblePeripheralUUIDs = NSMutableOrderedSet()
    var visiblePeripherals = [String: Peripheral]()

    weak var delegate: BluetoothManagerDelegate?

    override init() {
        super.init()
        let options = [CBCentralManagerOptionShowPowerAlertKey: true]
        manager = CBCentralManager(delegate: self, queue: queue, options: options)
    }

    func startScanning() {
        visiblePeripheralUUIDs.removeAllObjects()
        visiblePeripherals.removeAll()
        manager.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning() {
        manager.stopScan()
    }

    func connectTo(peripheral: Peripheral) {
        manager.connect(peripheral.peripheral, options: nil)
        updateState(uuid: peripheral.UUID, state: .processing)
    }

    func disconnect(peripheral: Peripheral) {
        //close caracteristics and services notifications before canceling
        manager.cancelPeripheralConnection(peripheral.peripheral)
        updateState(uuid: peripheral.UUID, state: .processing)
    }

    fileprivate func updateState(uuid: String, state: PeripheralConnectState) {
        let currentPeripheral = visiblePeripherals[uuid]
        currentPeripheral?.connectionState = state
        DispatchQueue.main.async {
            currentPeripheral?.delegate?.didUpdateState(state: state)
        }
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

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        print("Peripheral found with name: \(peripheral.name)\nUUID: \(peripheral.identifier.uuidString)\nRSSI: \(RSSI)\nAdvertisement Data: \(advertisementData)")
        let uuid = peripheral.identifier.uuidString

        if let visible = visiblePeripherals[peripheral.identifier.uuidString] {
            visible.RSSI = RSSI.stringValue
        }
        else {
            visiblePeripheralUUIDs.add(peripheral.identifier.uuidString)
            visiblePeripherals[peripheral.identifier.uuidString] = Peripheral(peripheral: peripheral,
                                                                              RSSI: RSSI.stringValue, advertisementDictionary: advertisementData as NSDictionary)
        }
        DispatchQueue.main.async {
            self.delegate?.didUpdateScan()
        }
    }
}

extension BluetoothManager {

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("🤢 update state : [connected]")
        updateState(uuid: peripheral.identifier.uuidString, state: .connected)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("🤢 update state : [failedToConnect]")
        updateState(uuid: peripheral.identifier.uuidString, state: .failedToConnect)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("🤢 update state : [disconnected]")
        updateState(uuid: peripheral.identifier.uuidString, state: .disconnected)
    }
}
