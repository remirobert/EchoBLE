//
//  ScanListViewController.swift
//  EchoBLE
//
//  Created by Remi Robert on 08/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class ScanListViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        BluetoothManager.shared.delegate = self
        tableview.register(UINib(nibName: "ScanListPeripheralTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableview.dataSource = self
    }
}

extension ScanListViewController: BluetoothManagerDelegate {

    func didUpdateScan() {
        tableview.reloadData()
    }
}

extension ScanListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BluetoothManager.shared.visiblePeripherals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! ScanListPeripheralTableViewCell

        guard let indexKey = BluetoothManager.shared.visiblePeripheralUUIDs.object(at: indexPath.row) as? String,
            let peripheral = BluetoothManager.shared.visiblePeripherals[indexKey] else {
            return cell
        }
        cell.configure(peripheral: peripheral)
        return cell
    }
}
