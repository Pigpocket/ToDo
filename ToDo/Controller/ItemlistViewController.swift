//
//  ItemlistViewController.swift
//  ToDo
//
//  Created by Tomas Sidenfaden on 7/17/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }
    
    @IBAction func addItem(_ sender: Any) {
        if let nextViewController =
            storyboard?.instantiateViewController(
                withIdentifier: "InputViewController")
                as? InputViewController {
            present(nextViewController, animated: true, completion: nil)
        }
    }
}
