//
//  ConnectionPeripheralStateTableViewCell.swift
//  EchoBLE
//
//  Created by Remi Robert on 12/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class ConnectionPeripheralStateTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonState: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        indicator.hidesWhenStopped = true
    }

    func configure(state: DeviceConnectState) {
        indicator.stopAnimating()
        buttonState.isHidden = false
        switch state {
        case .connected:
            buttonState.setTitle("Disconnect", for: .normal)
            buttonState.setTitleColor(UIColor.red, for: .normal)
        case .disconnected:
            buttonState.setTitle("Connect", for: .normal)
            buttonState.setTitleColor(UIColor.black, for: .normal)
        case .failedToConnect:
            buttonState.setTitle("Fail to connect", for: .normal)
            buttonState.setTitleColor(UIColor.red, for: .normal)
        case .processing:
            indicator.isHidden = false
            indicator.startAnimating()
            buttonState.isHidden = true
        }
    }
}
