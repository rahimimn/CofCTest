//
//  New StudentViewController.swift
//  CofCApp
//
//  Created by Rahimi, Meena Nichole (Student) on 6/10/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit

class NewStudentViewController: UIViewController, UITextFieldDelegate{

    var wasSubmitted = false

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var startTerm: UITextField!
    
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        startTerm.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Editing is about to begin")
        return true
    }
    
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        print("Editing began")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("Editing is about to end")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Editing ended")
        textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        print(textField.text ?? "wELP")
    }

    
    @IBAction func submitStudent(_ sender: UIBarButtonItem) {
        uploadStudent()
    }
    
}
