//
//  AddVehicleDataTableViewController.swift
//  vehicleWise
//
//  Created by student on 02/05/24.
//

import UIKit

protocol AddVehicleDelegate: AnyObject {
    func didAddNewVehicle()
}

class AddVehicleDataTableViewController: UITableViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var vehicleNumberTextFeild: UITextField!
    weak var delegate: AddVehicleDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateSaveButtonState()
    }

    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        guard let vehicleNumber = vehicleNumberTextFeild.text, !vehicleNumber.isEmpty else { return }
                            
            // Create a new VehicleWiseList object
            let newVehicle = VehicleWiseList(vehicleNumber: vehicleNumber, imageNumberPlate: "numbersign")
                            
            // Add the new vehicle to the data model
            dataModel.addVehicleToVehicleList(newVehicle: newVehicle)
            delegate?.didAddNewVehicle()
        dismiss(animated: true, completion: nil)
                            
            // Save the updated vehicle list locally
           // DataModel.saveToFileVehicles(vehicleList: dataModel.getVehicleList())
            
            // Perform unwind segue to return to VehicleListViewController
           // performSegue(withIdentifier: "saveUnwindVehicle", sender: self)
    }
    func updateSaveButtonState() {
           // Enable the save button only if the text field is not empty
           let vehicleNumber = vehicleNumberTextFeild.text ?? ""
           saveButton.isEnabled = !vehicleNumber.isEmpty
       }
    


    // Update save button state when text field value changes

    @IBAction func textFieldDidChange(_ sender: Any) {
        updateSaveButtonState()
    }
    
}
