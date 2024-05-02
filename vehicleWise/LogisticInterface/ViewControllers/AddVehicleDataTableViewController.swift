//
//  AddVehicleDataTableViewController.swift
//  vehicleWise
//
//  Created by student on 02/05/24.
//

import UIKit

class AddVehicleDataTableViewController: UITableViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var vehicleNumberTextFeild: UITextField!
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
                            
            // Save the updated vehicle list locally
            DataModel.saveToFileVehicles(vehicleList: dataModel.getVehicleList())
            
            // Perform unwind segue to return to VehicleListViewController
            performSegue(withIdentifier: "saveUnwindVehicle", sender: self)
    }
    func updateSaveButtonState() {
           // Enable the save button only if the text field is not empty
           let vehicleNumber = vehicleNumberTextFeild.text ?? ""
           saveButton.isEnabled = !vehicleNumber.isEmpty
       }
    
//override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "saveUnwindVehicle" {
//        guard let destinationVC = segue.destination as? VehicleListViewController else { return }
//        
//        // Pass the newly added vehicle to VehicleListViewController
//        if let vehicleNumber = vehicleNumberTextFeild.text, !vehicleNumber.isEmpty {
//            let newVehicle = VehicleWiseList(vehicleNumber: vehicleNumber, imageNumberPlate: "numbersign")
//            destinationVC.newVehicle = newVehicle
//        }
//    }
//}

    // Update save button state when text field value changes

    @IBAction func textFieldDidChange(_ sender: Any) {
        updateSaveButtonState()
    }
    
}
