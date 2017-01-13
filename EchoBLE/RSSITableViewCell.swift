//
//  RSSITableViewCell.swift
//  EchoBLE
//
//  Created by Remi Robert on 13/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class RSSITableViewCell: UITableViewCell {

    @IBOutlet weak var labelValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(device: Device) {
        labelValue.text = device.RSSI
    }
}
