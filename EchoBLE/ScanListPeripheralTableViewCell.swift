//
//  ScanListPeripheralTableViewCell.swift
//  EchoBLE
//
//  Created by Remi Robert on 09/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class ScanListPeripheralTableViewCell: UITableViewCell {

    @IBOutlet weak var labelRSSI: UILabel!
    @IBOutlet weak var labelNamePeripheral: UILabel!
    @IBOutlet weak var labelUUIDPeripheral: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(peripheral: Peripheral) {
        self.labelNamePeripheral.text = peripheral.name
        self.labelRSSI.text = peripheral.RSSI
        self.labelUUIDPeripheral.text = peripheral.UUID

        self.labelNamePeripheral.textColor = peripheral.connectable ?
            UIColor.green.withAlphaComponent(0.5) : UIColor.orange.withAlphaComponent(0.5)
    }
}
