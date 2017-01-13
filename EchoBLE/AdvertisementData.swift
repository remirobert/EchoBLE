//
//  AdvertisementData.swift
//  EchoBLE
//
//  Created by Remi Robert on 10/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import CoreBluetooth

struct AdvertisementData {

    var keys: NSMutableOrderedSet
    var values: [String: AdvertisementType]

    private func parseData(data: Any?) -> AdvertisementType? {
        if let id = data as? CBUUID {
            return id.uuidString
        }
        if let stringData = data as? String {
            return stringData
        }
        if let data = data as? Data {
            return data
        }
        if let value = data as? NSNumber {
            return value
        }
        return nil
    }

    init(datas: NSDictionary, allowList: Bool = true) {
        let allKeys = datas.allKeys as? [String] ?? []
        values = [:]
        keys = NSMutableOrderedSet()

        for key in allKeys {
            let data = datas[key]
            print("🙀 [\(key)] : \(data)")

            if let data = parseData(data: data) {
                keys.add(key)
                values[key] = data
            }

            //            if let stringData = data as? String {
            //                keys.add(key)
            //                values[key] = stringData
            //            }
            //            if let data = data as? Data {
            //                keys.add(key)
            //                values[key] = data
            //            }
            //            if let value = data as? NSNumber {
            //                keys.add(key)
            //                values[key] = value
            //            }
            if let listData = data as? [Any] {
                let datas = listData.flatMap({ return parseData(data: $0) })
                print("parse datas list : \(datas)")
                keys.add(key)
                values[key] = datas
            }
        }
    }
}
