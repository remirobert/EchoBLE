//
//  RSSI.swift
//  EchoBLE
//
//  Created by Remi Robert on 13/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

struct RSSIValue {
    let value: String
    let timestamp: TimeInterval

    init(value: String) {
        self.value = value
        timestamp = NSDate.timeIntervalSinceReferenceDate
    }
}

class RSSIContainer {
    private var values = [RSSIValue]()

    func append(value: String) {
        values.append(RSSIValue(value: value))
        if values.count > 20 {
            values.remove(at: 0)
        }
    }

    func current() -> String? {
        return values.last?.value
    }
}
