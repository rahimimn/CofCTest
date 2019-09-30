//
//  NewStudentViewController+Uploading.swift
//  CofCApp
//
//  Created by Rahimi, Meena Nichole (Student) on 6/10/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import Foundation
import SalesforceSDKCore
    
extension NewStudentViewController {
        
        /// Logs the given error.
        ///
        /// This project doesn't do any sophisticated error checking, and simply
        /// uses this as the failure handler for `RestClient` requests. In a real-world
        /// application, be sure to replace this with information presented to the user
        /// that can be acted on.
        ///
        /// - Parameters:
        ///   - error: The error to be logged.
        ///   - urlResponse: Ignored; this argument provides compatibility with
        ///     the `SFRestFailBlock` API.
        private func handleError(_ error: Error?, urlResponse: URLResponse? = nil) {
            let errorDescription: String
            if let error = error {
                errorDescription = "\(error)"
            } else {
                errorDescription = "An unknown error occurred."
            }
            
            if(alert.isViewLoaded){
                alert.dismiss(animated: true)
            }
            alert = UIAlertController(title: "We're sorry, an error has occured. This student has not been saved.", message: errorDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in self.unwindToStudents()}))
            present(self.alert, animated: true)
            
            SalesforceLogger.e(type(of: self), message: "Failed to successfully complete the REST request. \(errorDescription)")
        }
        
        /// Begins the process of uploading the student details to the server.
        func uploadStudent() {
            SalesforceLogger.d(type(of: self), message: "Starting")
            alert = UIAlertController(title: nil, message: "Submitting", preferredStyle: .alert)
            let loadingModal = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingModal.hidesWhenStopped = true
            loadingModal.style = .gray
            loadingModal.startAnimating()
            alert.view.addSubview(loadingModal)
            present(alert, animated: true, completion: nil)
            self.createStudent()
           }
    
        
        /// Creates a new Student record from the transcribed text and map location.
        ///
        /// - Parameter accountID: The ID of the account with which the student is
        ///   to be associated.
        private func createStudent() {
            print("Creating student")
            var record = [String: Any]()
            record["Email"] = email.text
            record["FirstName"] = firstName.text
            record["LastName"] = lastName.text
            record["TargetX_SRMb__Anticipated_Start_Term__c"] = startTerm.text
            print("About to request upsert")
            
            let upsertRequest = RestClient.shared.requestForUpsert(withObjectType: "Contact", externalIdField: "Id", externalId: nil, fields: record)
            print("Request made")
            RestClient.shared.send(request: upsertRequest, onFailure: { (error, urlResponse) in
                SalesforceLogger.d(type(of:self), message:"Error invoking: \(error ?? "welp" as! Error)")
                
            }) {(response, urlResponse) in
                os_log("\nSuccessful response received")
                self.unwindToStudents()
                
                
            }

        
            }

        


        
    
        
        /// Dismisses the current modal and returns the user to existing students.
        private func unwindToStudents() {
            wasSubmitted = true
            // Unwind back to students. UI calls must be performed on the main thread.
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "unwindFromNewStudent", sender: self)
            }
        }
}


