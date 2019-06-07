//  ObjectListDataSource.swift
//  
//
//  Created by Rahimi, Meena Nichole (Student) on 6/7/19.
//

import Foundation
import SalesforceSDKCore


/// Protocol used by classes that wish to be informed when an "StudentListDataSource" instance has been updated.
protocol StudentListDataSourceDelegate: AnyObject {
    
    /// This method is called when an student list data source has updated the value of its "records" property
    /// - Parameter dataSource: The data source that was updated.
    func studentListDataSourceDidUpdateRecords(_ dataSource: StudentListDataSource)
    
    }


/// Supplies the data to a "UITableView" for a list of objects returned by a SOQL query.
/// An instance of this class can be used as a table view's "data source".
class StudentListDataSource: NSObject {
    
    
    /// A dictionary with string keys.
    typealias salesForceRecord = [String: Any]
    
    /// A closure that configures a given table view cell using the given dictionary of values retrieved from the salesforce server.
    typealias CellConfigurator = (salesForceRecord, UITableViewCell) -> Void
    
    /// The query that is executed when "fetchData()" is called.
    let soqlQuery: String
    
    /// The reuse identifier to use for dequeing cells from the table view.
    let cellReuseIdentifier: String
    
    /// The closure to call for each cell being provided by the data source.
    /// This will be called for each record in the list as it is displayed.
    let cellConfigurator: CellConfigurator
    
    /// The records returned from the Salesforce server.
    /// Each record is a dictionary containing the fields requested in the query.
    private(set) var records: [salesForceRecord] = []

    /// The delegate to notify when the list of records is updated.
    weak var delegate: StudentListDataSourceDelegate?

    ///Initializes a data source with a SOQL query to execute.
    ///
    /// - Parameters:
    ///     - soqlQuery: The query that is executed when "fetchData()" is called.
    ///     - cellReuseIdentifier: The reuse identifier to use for dequeing cells from the table view.
    ///     - cellConfigurator: The closure to call for each cell being provided by the data source.
    init(soqlQuery: String, cellReuseIdentifier: String, cellConfigurator: @escaping CellConfigurator){
        self.soqlQuery = soqlQuery
        self.cellReuseIdentifier = cellReuseIdentifier
        self.cellConfigurator = cellConfigurator
        super.init()
    }

    
    
    /// Logs the given error.
    /// This is a simple error checker and will need to be replaced to present the user with information.
    ///
    /// - Parameters:
    ///     - error: The error to be logged in the console.
    ///     - urlResponse: Ignored: this arguments provides compatibility with the "SFRestFailBlock" API.
    private func handleError(_ error: Error?, urlResponse: URLResponse? = nil) {
        let errorDescription: String
        if let error = error {
            errorDescription = "\(error)"
        } else {
            errorDescription = "An unknown error occurred."
        }
        SalesforceLogger.e(type(of: self), message: "Failed to successfully complete the REST request. \(errorDescription)")
    }
    
    
    /// Executes the "soqlQuery"
    ///
    /// When it successfully completes, the "records" property is set to the results, and the delegate is notified of the update.
    @objc func fetchData() {
        guard !soqlQuery.isEmpty else { return }
        let request = RestClient.shared.request(forQuery: soqlQuery)
        RestClient.shared.send(request: request, onFailure: handleError) { [weak self] response, _ in
            guard let self = self else { return }
            var resultsToReturn = [salesForceRecord]()
            if let dictionaryResponse = response as? [String: Any],
                let records = dictionaryResponse["records"] as? [salesForceRecord] {
                resultsToReturn = records
            }
            DispatchQueue.main.async {
                self.records = resultsToReturn
                self.delegate?.studentListDataSourceDidUpdateRecords(self)
            }
        }
    }
}

extension StudentListDataSource: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cellConfigurator(records[indexPath.row], cell)
        return cell
    }
}
