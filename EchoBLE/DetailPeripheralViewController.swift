//
//  DetailPeripheralViewController.swift
//  EchoBLE
//
//  Created by Remi Robert on 09/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class DetailPeripheralViewController: UIViewController {

    var peripheral: Peripheral!

    @IBOutlet weak var tableview: UITableView!

    @objc func connectionButton() {
        switch peripheral.connectionState {
        case .connected:
            BluetoothManager.shared.disconnect(peripheral: peripheral)
        case .disconnected:
            BluetoothManager.shared.connectTo(peripheral: peripheral)
        default:
            break
        }
    }

    @objc func back(sender: AnyObject!) {
        peripheral.delegate = nil
        BluetoothManager.shared.disconnect(peripheral: peripheral)
        let _ = navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailPeripheralViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton

        let nib = UINib(nibName: "DetailPeripheralNameSectionHeader", bundle: nil)
        tableview.register(nib, forHeaderFooterViewReuseIdentifier: "header")

        let nibValue = UINib(nibName: "AdverstisementDataTableViewCell", bundle: nil)
        tableview.register(nibValue, forCellReuseIdentifier: "cellAd")

        let nibValueConnect = UINib(nibName: "ConnectionPeripheralStateTableViewCell", bundle: nil)
        tableview.register(nibValueConnect, forCellReuseIdentifier: "cellConnect")

        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        tableview.sectionHeaderHeight = 109

        peripheral.delegate = self

        print("keys : \(peripheral.advertisementData.keys)")
    }
}

extension DetailPeripheralViewController: PeripheralStateUpdateDelegate {

    func didUpdateState(state: PeripheralConnectState) {
        print("🦄 receive delegate update state")
        tableview.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
    }
}

extension DetailPeripheralViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 109 : 24
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return UIView()
        }
        guard let header = tableview.dequeueReusableHeaderFooterView(withIdentifier: "header")
            as? DetailPeripheralNameSectionHeader else {
            return UIView()
        }
        header.configure(peripheral: peripheral)
        return header
    }
}

extension DetailPeripheralViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? peripheral.advertisementData.values.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellConnect")
                as? ConnectionPeripheralStateTableViewCell else {
                    return UITableViewCell()
            }
            cell.buttonState.addTarget(self, action: #selector(DetailPeripheralViewController.connectionButton), for: .touchUpInside)
            cell.configure(state: peripheral.connectionState)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellAd")
            as? AdverstisementDataTableViewCell else {
            return UITableViewCell()
        }
        guard let key = peripheral.advertisementData.keys[indexPath.row] as? String else {
            return UITableViewCell()
        }

        if let value = peripheral.advertisementData.values[key] {
            cell.configure(value: value, key: key)
        }
        return cell
    }
}
