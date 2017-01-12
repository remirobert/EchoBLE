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
        let nib = UINib(nibName: "ScanListPeripheralTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "cell")
        tableview.dataSource = self
        tableview.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail" {
            guard let controller = segue.destination as? DetailPeripheralViewController else {return}
            controller.peripheral = sender as? Peripheral
        }
    }
}

extension ScanListViewController: BluetoothManagerDelegate {

    func didUpdateScan() {
        tableview.reloadData()
    }
}

extension ScanListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexKey = BluetoothManager.shared.visiblePeripheralUUIDs.object(at: indexPath.row) as? String,
            let peripheral = BluetoothManager.shared.visiblePeripherals[indexKey] else {
                return
        }
        self.performSegue(withIdentifier: "segueDetail", sender: peripheral)
    }
}

extension ScanListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BluetoothManager.shared.visiblePeripherals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as?
            ScanListPeripheralTableViewCell else {
            return UITableViewCell()
        }

        guard let indexKey = BluetoothManager.shared.visiblePeripheralUUIDs.object(at: indexPath.row) as? String,
            let peripheral = BluetoothManager.shared.visiblePeripherals[indexKey] else {
            return cell
        }
        cell.configure(peripheral: peripheral)
        return cell
    }
}
