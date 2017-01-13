//
//  PeripheralManagerDelegate.swift
//  EchoBLE
//
//  Created by Remi Robert on 13/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

protocol PeripheralManagerDelegate: class {
    func didUpdateState(state: DeviceConnectState)
    func didUpdateRSSI()
}
