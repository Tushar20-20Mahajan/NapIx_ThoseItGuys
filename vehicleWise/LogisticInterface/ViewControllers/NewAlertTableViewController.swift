//
//  NewAlertTableViewController.swift
//  vehicleWise
//
//  Created by student on 01/05/24.
//

import UIKit
protocol AddNewScheduleDelegate: AnyObject {
    func didAddNewScheduleToRoute()
}

class NewAlertTableViewController: UITableViewController , SelectVehicleNumberTableViewControllerDelegate , SelectDriverNameTableViewControllerDelegate{

    
    @IBOutlet weak var vehicleNumberLabel: UILabel!
    
    @IBOutlet weak var driverNameLabel: UILabel!
    
    
    @IBOutlet weak var fromTextFeild: UITextField!
    
    @IBOutlet weak var toTextFeild: UITextField!
    
    @IBOutlet weak var dateAndTime: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    weak var delegate: AddNewScheduleDelegate?
       
       var selectedVehicle: VehicleWiseList?
       var selectedDriver: DriversList?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateSaveButtonState()
        updateVehicleName()
        updateDriverName()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
    }

    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let from = fromTextFeild.text,
                  let to = toTextFeild.text,
                  let selectedVehicle = selectedVehicle,
                  let selectedDriver = selectedDriver else {
                // Display an alert or handle the case where data is incomplete
                return
            }
            
            // Create a new AlertBoardDataDisplayInformation object
            let newAlert = AlertBoardDataDisplayInformation(imageAlert: "GreyAlert.jpeg",
                                                            route: "\(from) - \(to)",
                                                            vehicleNumber: selectedVehicle.vehicleNumber,
                                                            driverName: selectedDriver.name)
            
            // Add the new alert to your array
        dataModel.addScheduledAlertOnAlertBoard(newScheduledAlert: newAlert)
            
            // Notify the delegate that a new schedule has been added
            delegate?.didAddNewScheduleToRoute()
            
            // Dismiss the view controller
            dismiss(animated: true, completion: nil)
    }
    
    func didSelectVehicle(vehicleNumber: VehicleWiseList) {
            selectedVehicle = vehicleNumber
            vehicleNumberLabel.text = vehicleNumber.vehicleNumber
        
            updateSaveButtonState()
        }
        
        func didSelectDriver(driverName: DriversList) {
            selectedDriver = driverName
            driverNameLabel.text = driverName.name
            
            updateSaveButtonState()
        }
    private func updateSaveButtonState() {
            saveButton.isEnabled = !(fromTextFeild.text?.isEmpty ?? true) &&
                                   !(toTextFeild.text?.isEmpty ?? true) &&
                                   selectedVehicle != nil &&
                                   selectedDriver != nil
        }
    func updateVehicleName() {
        if let selectedVehicle = selectedVehicle {
            vehicleNumberLabel.text = selectedVehicle.vehicleNumber
        } else {
            vehicleNumberLabel.text = "Select"
        }
    }

    func updateDriverName() {
        if let selectedDriver = selectedDriver {
            driverNameLabel.text = selectedDriver.name
        } else {
            driverNameLabel.text = "Select"
        }
    }

}
