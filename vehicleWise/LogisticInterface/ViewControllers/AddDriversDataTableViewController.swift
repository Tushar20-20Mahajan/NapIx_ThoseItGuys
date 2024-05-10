//
//  AddDriversDataTableViewController.swift
//  vehicleWise
//
//  Created by student on 01/05/24.
//

import UIKit

// Protocol to notify the delegate when a new driver is added
protocol AddDriversDelegate: AnyObject {
    func didAddNewDriver()
}

// View controller for adding new drivers to the list
class AddDriversDataTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var driverNameTextField: UITextField!
    @IBOutlet weak var driverMobileNumberTextField: UITextField!
    
    // MARK: - Properties
    
    weak var delegate: AddDriversDelegate? // Delegate to notify about adding new drivers
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false // Disable save button by default
    }
    
    // MARK: - Helper Methods
    
    // Update the state of the save button based on text field values
    func updateSaveButtonState() {
        let driverMobileNumber = driverMobileNumberTextField.text ?? ""
        let driverName = driverNameTextField.text ?? ""
        saveButton.isEnabled = !driverName.isEmpty && !driverMobileNumber.isEmpty
    }
    
    // MARK: - IBActions
    
    // Action method for cancel button
    @IBAction func cancelButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Action method for save button
    @IBAction func saveDataButtonWasPressed(_ sender: Any) {
        if let name = driverNameTextField.text, let phone = driverMobileNumberTextField.text {
            // Create a new driver object
            let newDriver = DriversList(name: name, mobileNumber: phone, imageDriver: "figure.seated.seatbelt")
            // Add the new driver to the data model
            dataModel.addDriversToDriverList(newDriver: newDriver)
            // Notify the delegate about adding a new driver
            delegate?.didAddNewDriver()
            // Dismiss the view controller
            dismiss(animated: true, completion: nil)
        }
    }
    
    // Action method to handle text changes in the driver mobile number text field
    @IBAction func driverMobileNumberTextFieldDidChange(_ sender: Any) {
        updateSaveButtonState() // Update save button state
    }
    
    // Action method to handle text changes in the driver name text field
    @IBAction func driverNameTextFieldDidChange(_ sender: Any) {
        updateSaveButtonState() // Update save button state
    }
}

