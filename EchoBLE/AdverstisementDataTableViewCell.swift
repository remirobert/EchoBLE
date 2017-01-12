//
//  AdverstisementDataTableViewCell.swift
//  EchoBLE
//
//  Created by Remi Robert on 10/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class AdverstisementDataTableViewCell: UITableViewCell {

    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var labelTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(value: AdvertisementType, key: String) {
        self.labelValue.text = value.displayValue()
        self.labelTitle.text = key
    }
}
