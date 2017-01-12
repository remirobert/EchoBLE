//
//  AdvertisementExtensionType.swift
//  EchoBLE
//
//  Created by Remi Robert on 12/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import Foundation

extension Data: AdvertisementType {
    func displayValue() -> String {
        return self.debugDescription
    }
}

extension String: AdvertisementType {
    func displayValue() -> String {
        return self
    }
}

extension NSNumber: AdvertisementType {
    func displayValue() -> String {
        return self.stringValue
    }
}
