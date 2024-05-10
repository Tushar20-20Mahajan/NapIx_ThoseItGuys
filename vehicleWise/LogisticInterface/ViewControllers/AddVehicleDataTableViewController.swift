//
//  AddVehicleDataTableViewController.swift
//  vehicleWise
//
//  Created by student on 02/05/24.
//

import UIKit

// Protocol to delegate the addition of a new vehicle
protocol AddVehicleDelegate: AnyObject {
    func didAddNewVehicle()
}

class AddVehicleDataTableViewController: UITableViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var vehicleNumberTextField: UITextField!
    
    // MARK: - Properties
    
    weak var delegate: AddVehicleDelegate?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update the state of the save button
        updateSaveButtonState()
    }

    // MARK: - IBActions
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        // Dismiss the view controller when cancel button is pressed
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        // Validate and save the new vehicle data
        
        guard let vehicleNumber = vehicleNumberTextField.text, !vehicleNumber.isEmpty else { return }
        
        // Create a new VehicleWiseList object
        let newVehicle = VehicleWiseList(vehicleNumber: vehicleNumber, imageNumberPlate: "numbersign")
        
        // Add the new vehicle to the data model
        dataModel.addVehicleToVehicleList(newVehicle: newVehicle)
        
        // Notify the delegate that a new vehicle has been added
        delegate?.didAddNewVehicle()
        
        // Dismiss the view controller
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    // Update the state of the save button based on text field value
    func updateSaveButtonState() {
        // Enable the save button only if the text field is not empty
        let vehicleNumber = vehicleNumberTextField.text ?? ""
        saveButton.isEnabled = !vehicleNumber.isEmpty
    }

    // MARK: - IBActions
    
    // Update the state of the save button when text field value changes
    @IBAction func textFieldDidChange(_ sender: Any) {
        updateSaveButtonState()
    }
}
