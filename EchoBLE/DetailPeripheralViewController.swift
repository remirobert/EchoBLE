//
//  DetailPeripheralViewController.swift
//  EchoBLE
//
//  Created by Remi Robert on 09/01/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class DetailPeripheralViewController: UIViewController {

    var peripheralManager: PeripheralManager!

    @IBOutlet weak var tableview: UITableView!

    @objc func connectionButton() {
        peripheralManager.manageConnection()
    }

    @objc func back(sender: AnyObject!) {
        peripheralManager.manageConnection(closeConnection: true)
        let _ = navigationController?.popViewController(animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        peripheralManager.manageConnection()
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

        let rssiNib = UINib(nibName: "RSSITableViewCell", bundle: nil)
        tableview.register(rssiNib, forCellReuseIdentifier: "cellRSSI")

        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        tableview.sectionHeaderHeight = 109

        peripheralManager.delegate = self
    }
}

extension DetailPeripheralViewController: PeripheralManagerDelegate {

    func didUpdateState(state: DeviceConnectState) {
        print("🦄 receive delegate update state")
        if state == .connected {
            peripheralManager.readServices()
        }
        tableview.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
    }

    func didUpdateRSSI() {
        tableview.reloadRows(at: [IndexPath(row: 1, section: 0)], with: UITableViewRowAnimation.automatic)
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
        header.configure(peripheral: peripheralManager.device)
        return header
    }
}

extension DetailPeripheralViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? peripheralManager.device.advertisementData.values.count : 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellConnect")
                    as? ConnectionPeripheralStateTableViewCell else {
                        return UITableViewCell()
                }
                cell.buttonState.addTarget(self, action: #selector(DetailPeripheralViewController.connectionButton), for: .touchUpInside)
                cell.configure(state: peripheralManager.device.connectionState)
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellRSSI") as? RSSITableViewCell else {
                    return UITableViewCell()
            }
            cell.configure(device: peripheralManager.device)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellAd")
            as? AdverstisementDataTableViewCell else {
            return UITableViewCell()
        }
        guard let key = peripheralManager.device.advertisementData.keys[indexPath.row] as? String else {
            return UITableViewCell()
        }

        if let value = peripheralManager.device.advertisementData.values[key] {
            cell.configure(value: value, key: key)
        }
        return cell
    }
}
