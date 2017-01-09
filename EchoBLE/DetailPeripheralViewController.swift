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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.register(UINib(nibName: "DetailPeripheralNameSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        tableview.delegate = self
        tableview.dataSource = self
    }
}

extension DetailPeripheralViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableview.dequeueReusableHeaderFooterView(withIdentifier: "header") as! DetailPeripheralNameSectionHeader
        header.configure(peripheral: peripheral)
        return header
    }
}

extension DetailPeripheralViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
