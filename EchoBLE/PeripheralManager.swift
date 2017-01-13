//
//  PeripheralManager.swift
//  EchoBLE
//
//  Created by Remi Robert on 13/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import Foundation
import CoreBluetooth

class PeripheralManager: NSObject {

    var device: Device

    weak var delegate: PeripheralManagerDelegate?
    weak var timer: Timer?

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.device.peripheral.readRSSI()
        })
    }

    func stopTimer() {
        timer?.invalidate()
    }

    deinit {
        stopTimer()
    }

    init(device: Device) {
        self.device = device
        super.init()
        self.device.delegate = self
    }

    func readServices() {
        device.peripheral.delegate = self
        device.peripheral.discoverServices(nil)
        device.peripheral.readRSSI()
    }

    func manageConnection(closeConnection: Bool = false) {
        if closeConnection {
            BluetoothManager.shared.disconnect(device: device)
        }
        switch device.connectionState {
        case .connected:
            BluetoothManager.shared.disconnect(device: device)
        case .disconnected:
            BluetoothManager.shared.connectTo(device: device)
        default:
            break
        }
    }
}

extension PeripheralManager: DeviceStateUpdateDelegate {

    func didUpdateState(state: DeviceConnectState) {
        if state == .connected {
            startTimer()
        } else {
            stopTimer()
        }
        DispatchQueue.main.async {
            self.delegate?.didUpdateState(state: state)
        }
    }
}

extension PeripheralManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("🐸🍰 read RSSI device : \(RSSI)")
        device.RSSI.append(value: RSSI.stringValue)
        DispatchQueue.main.async {
            self.delegate?.didUpdateRSSI()
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("🐼 did discover services : \(peripheral.services)")
    }
}
