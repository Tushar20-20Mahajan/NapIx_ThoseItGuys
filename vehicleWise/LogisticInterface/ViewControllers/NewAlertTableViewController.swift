//
//  NewAlertTableViewController.swift
//  vehicleWise
//
//  Created by student on 01/05/24.
//

import UIKit

// Protocol to communicate adding new schedule to the route
protocol AddNewScheduleDelegate: AnyObject {
    func didAddNewScheduleToRoute()
}

// View controller for adding a new alert/schedule
class NewAlertTableViewController: UITableViewController , SelectVehicleNumberTableViewControllerDelegate , SelectDriverNameTableViewControllerDelegate{
   
    // MARK: - IBOutlets
    
    @IBOutlet weak var vehicleNumberLabel: UILabel! // Label to display selected vehicle number
    @IBOutlet weak var driverNameLabel: UILabel! // Label to display selected driver name
    @IBOutlet weak var fromTextFeild: UITextField! // Text field for inputting departure location
    @IBOutlet weak var toTextFeild: UITextField! // Text field for inputting destination location
    @IBOutlet weak var dateAndTime: UIDatePicker! // Date picker for selecting date and time
    @IBOutlet weak var saveButton: UIBarButtonItem! // Button to save the new schedule
    
    // MARK: - Properties
    
    weak var delegate: AddNewScheduleDelegate?
    var selectedVehicle: VehicleWiseList? // Selected vehicle
    var selectedDriver: DriversList? // Selected driver
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tap gestures for selecting vehicle and driver
        let tapGestureVehicle = UITapGestureRecognizer(target: self, action: #selector(vehicleNumberLabelTapped))
        vehicleNumberLabel.addGestureRecognizer(tapGestureVehicle)
        vehicleNumberLabel.isUserInteractionEnabled = true
        
        let tapGestureDriver = UITapGestureRecognizer(target: self, action: #selector(driverNameLabelTapped))
        driverNameLabel.addGestureRecognizer(tapGestureDriver)
        driverNameLabel.isUserInteractionEnabled = true
        
        // Disable save button by default
        saveButton.isEnabled = false
    }

    // MARK: - Actions
    
    @objc func vehicleNumberLabelTapped() {
        presentVehicleList()
    }
    
    @objc func driverNameLabelTapped() {
        presentDriverList()
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
        // Validate inputs and save the new schedule
        guard let from = fromTextFeild.text,
              let to = toTextFeild.text,
              let selectedVehicle = selectedVehicle,
              let selectedDriver = selectedDriver else {
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let selectedDateAndTime = dateFormatter.string(from: dateAndTime.date)
        let passId = dataModel.generatePassKey()

        // Print selected details (for testing)
        print(from)
        print(to)
        print(selectedDriver)
        print(selectedVehicle.vehicleNumber)
        print(selectedDateAndTime)
        print(passId)

        // Add the new scheduled alert to the data model
        dataModel.addScheduledAlertOnAlertBoard(newScheduledAlert: (passId, AlertBoardDataDisplayInformation(imageAlert: "GreyAlert.jpeg", route: "\(from) - \(to)", vehicleNumber: "\(selectedVehicle.vehicleNumber)", driverName: DriversList(name: selectedDriver.name, mobileNumber: selectedDriver.mobileNumber, imageDriver: "figure.seated.seatbelt"), departureDetails: selectedDateAndTime, alertTimmings: [])))
        dataModel.addNewPassIDRoute(newPasID: passId)

        // Inform delegate about the new schedule addition
        delegate?.didAddNewScheduleToRoute()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Delegate Methods
    
    func didSelectVehicle(_ controller: showVehicleListViewController, didSelect vehicleNumber: VehicleWiseList) {
        // Update selected vehicle and label
        self.selectedVehicle = vehicleNumber
        updateVehicleName()
    }
    
    func didSelectDriver(driverName: DriversList) {
        // Update selected driver and label
        selectedDriver = driverName
        driverNameLabel.text = driverName.name
        updateDriverName()
    }

    // MARK: - Helper Methods
    
    func updateVehicleName() {
        // Update vehicle label with selected vehicle number
        if let selectedVehicle = selectedVehicle {
            vehicleNumberLabel.text = selectedVehicle.vehicleNumber
        } else {
            vehicleNumberLabel.text = "Select"
        }
    }

    func updateDriverName() {
        // Update driver label with selected driver name
        if let selectedDriver = selectedDriver {
            driverNameLabel.text = selectedDriver.name
        } else {
            driverNameLabel.text = "Select"
        }
    }
    
    func presentVehicleList() {
        // Present vehicle list to select a vehicle
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vehicleListVC = storyboard.instantiateViewController(withIdentifier: "selectTheVehicle") as! showVehicleListViewController
        let navController = UINavigationController(rootViewController: vehicleListVC)
        vehicleListVC.delegate = self
        present(navController, animated: true, completion: nil)
    }
    
    func  presentDriverList() {
        // Present driver list to select a driver
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let driverListVC = storyBoard.instantiateViewController(withIdentifier: "selectTheDriver") as! showDriversListViewController
        let navController = UINavigationController(rootViewController: driverListVC)
        driverListVC.title = "Driver List"
        driverListVC.delegate = self
        present(navController, animated: true, completion: nil)
    }
    
    func updateSaveButtonState() {
        // Enable save button only if all required fields are filled
        let fromLocation = fromTextFeild.text ?? ""
        let toLocation = toTextFeild.text ?? ""
        saveButton.isEnabled = !fromLocation.isEmpty && !toLocation.isEmpty && (vehicleNumberLabel.text != "Select") && (driverNameLabel.text != "Select")
    }

    @IBAction func fromTextDidChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func toTextDidChanged(_ sender: Any) {
        updateSaveButtonState()
    }
}

