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

    
    /// Used by the storyboard to unwind other scenes back
    /// to this view controller.
    ///
    /// Fetches new data whenever a new claim is submitted.
    ///
    /// - Parameter segue: The segue to unwind.
//    @IBAction func unwindFromNewStudent(segue: UIStoryboardSegue) {
//        let newStudentViewController = segue.source as! NewStudentViewController
//        if newStudentViewController.wasSubmitted {
//            dataSource.fetchData()
//        }
//    }

    //these are the fields that are being pulled from the server
    private let dataSource = StudentListDataSource(soqlQuery: "SELECT Name, TargetX_SRMb__BannerID__c FROM Contact", cellReuseIdentifier: "StudentPrototype") { record, cell in
        let name = record["Name"] as? String ?? ""
        let  studentId = record["TargetX_SRMb__BannerID__c"] as? String ?? ""
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = "Contact ID: \(studentId)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource.delegate = self
        self.tableView.delegate = self
        self.tableView.activityIndicatorView.startAnimating()
        self.tableView.dataSource = self.dataSource
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self.dataSource, action: #selector(self.dataSource.fetchData), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl!)
        self.dataSource.fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewStudentDetails" {
            let destination = segue.destination as! StudentDetailsTableViewController
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)!
            if let studentID = self.dataSource.records[indexPath.row]["TargetX_SRMb__BannerID__c"] as? String {
                destination.studentID = studentID
            }
        }
    }
}

extension ExistingStudentsTableViewController: StudentListDataSourceDelegate {
    func studentListDataSourceDidUpdateRecords(_ dataSource: StudentListDataSource) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            self.tableView.activityIndicatorView.stopAnimating()
        }
    }
}
