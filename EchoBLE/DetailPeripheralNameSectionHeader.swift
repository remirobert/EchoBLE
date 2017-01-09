//
//  DetailPeripheralNameSectionHeader.swift
//  EchoBLE
//
//  Created by Remi Robert on 09/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class DetailPeripheralNameSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelUUID: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(peripheral: Peripheral) {
        self.labelName.text = peripheral.name
        self.labelUUID.text = peripheral.UUID
    }
}
