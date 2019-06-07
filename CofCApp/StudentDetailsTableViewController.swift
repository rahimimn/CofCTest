//
//  StudentDetailsTableViewController.swift
//  CofCApp
//
//  Created by Rahimi, Meena Nichole (Student) on 6/7/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SalesforceSDKCore

class StudentDetailsTableViewController: UITableViewController {
    var studentID: String?
    var dataSource: ObjectLayoutDataSource!
    let reuseIdentifier = "StudentDetailPrototype"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bannerID = studentID {
            
            self.dataSource = ObjectLayoutDataSource(objectType: "Contact", objectId: bannerID, cellReuseIdentifier: self.reuseIdentifier) { field, cell in
                cell.textLabel?.text = field.value
                cell.detailTextLabel?.text = field.label
            }
            self.dataSource.delegate = self
            self.tableView.delegate = self
            self.tableView.activityIndicatorView.startAnimating()
            self.tableView.dataSource = dataSource
            self.refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self.dataSource, action: #selector(self.dataSource.fetchData), for: UIControl.Event.valueChanged)
            self.tableView.addSubview(refreshControl!)
            self.dataSource.fetchData()
        }
    }
}

extension StudentDetailsTableViewController: ObjectLayoutDataSourceDelegate {
    func objectLayoutDataSourceDidUpdateFields(_ dataSource: ObjectLayoutDataSource) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            self.tableView.activityIndicatorView.stopAnimating()
        }
    }









}

