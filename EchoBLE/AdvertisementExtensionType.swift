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

extension Array: AdvertisementType {
    func displayValue() -> String {
        return self.reduce("") { (result, element) -> String in
            guard let element = element as? AdvertisementType else { return result }
            return "\(result)\(result.characters.count > 0 ? "\n" : "")\(element.displayValue())"
        }
    }
}
