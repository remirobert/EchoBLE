//
//  PeripheralStateUpdateDelegate.swift
//  EchoBLE
//
//  Created by Remi Robert on 12/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

protocol DeviceStateUpdateDelegate: class {
    func didUpdateState(state: DeviceConnectState)
}
