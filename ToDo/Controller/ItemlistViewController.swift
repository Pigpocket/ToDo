//
//  ItemlistViewController.swift
//  ToDo
//
//  Created by Tomas Sidenfaden on 7/17/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    let itemManager = ItemManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager
    }
    
    @IBAction func addItem(_ sender: Any) {
        if let nextViewController =
            storyboard?.instantiateViewController(
                withIdentifier: "InputViewController")
                as? InputViewController {
            nextViewController.itemManager = itemManager
            present(nextViewController, animated: true, completion: nil)
        }
    }
}
