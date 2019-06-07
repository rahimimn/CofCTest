//
//  ExistingStudentsTableViewController.swift
//  CofCApp
//
//  Created by Rahimi, Meena Nichole (Student) on 6/7/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SalesforceSDKCore

class ExistingStudentsTableViewController: UITableViewController {

    
    private let dataSource = StudentListDataSource(soqlQuery: "SELECT LastName, FirstName, Email, BannerId, StartTerm, AnticipatedMajor FROM Student", cellReuseIdentifier: "StudentPrototype") {record, cell in
        let lastName = record["LastName"] as? String ?? ""
        let firstName = record["FirstName"] as? String ?? ""
        cell.textLabel?.text = lastName
        cell.textLabel?.text = firstName
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.dataSource.delegate = self as? StudentListDataSourceDelegate
        self.tableView.delegate = self
        self.tableView.activityIndicatorView.startAnimating()
        self.tableView.dataSource = self.dataSource
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self.dataSource, action: #selector(self.dataSource.fetchData), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl!)
        self.dataSource.fetchData()
        
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ViewStudentDetails"{
            let destination = segue.destination as! StudentDetailsTableViewController
        }
    }
}
