//
//  AdvertisementData.swift
//  EchoBLE
//
//  Created by Remi Robert on 10/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

struct AdvertisementData {

    var keys: NSMutableOrderedSet
    var values: [String: AdvertisementType]

    init(datas: NSDictionary) {
        let allKeys = datas.allKeys as? [String] ?? []
        values = [:]
        keys = NSMutableOrderedSet()

        for key in allKeys {
            let data = datas[key]
            print("🙀 [\(key)] : \(data)")
            if let stringData = data as? String {
                keys.add(key)
                values[key] = stringData
            }
            if let data = data as? Data {
                keys.add(key)
                values[key] = data
            }
            if let value = data as? NSNumber {
                keys.add(key)
                values[key] = value
            }
//            if let listData = data as? [Any] {
//            }
        }

    }
}
