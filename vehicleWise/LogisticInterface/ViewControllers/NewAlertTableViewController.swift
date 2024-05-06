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
        
        let tapGestureVehicle = UITapGestureRecognizer(target: self, action: #selector(vehicleNumberLabelTapped))
        vehicleNumberLabel.addGestureRecognizer(tapGestureVehicle)
        vehicleNumberLabel.isUserInteractionEnabled = true
        
        let tapGestureDriver = UITapGestureRecognizer(target: self, action: #selector(driverNameLabelTapped))
        driverNameLabel.addGestureRecognizer(tapGestureDriver)
        driverNameLabel.isUserInteractionEnabled = true
        saveButton.isEnabled = false
    }

    
        
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
        guard let from = fromTextFeild.text,
                  let to = toTextFeild.text,
                  let selectedVehicle = selectedVehicle,
                  let selectedDriver = selectedDriver else {
                // Display an alert or handle the case where data is incomplete
                return
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let selectedDateAndTime = dateFormatter.string(from: dateAndTime.date)
        let passId = dataModel.generatePassKey()

            print(from)
            print(to)
        print(selectedDriver.name)
        print(selectedVehicle.vehicleNumber)
            print(selectedDateAndTime)
        print(passId)

            // Here you can use `selectedDateAndTime` as a string representation of the selected date and time.
        dataModel.addScheduledAlertOnAlertBoard(newScheduledAlert: (passId, AlertBoardDataDisplayInformation(imageAlert: "GreyAlert.jpeg", route: "\(from) - \(to)", vehicleNumber: "\(selectedVehicle.vehicleNumber)", driverName: "\(selectedDriver.name)", departureDetails: selectedDateAndTime)))

            delegate?.didAddNewScheduleToRoute()
            dismiss(animated: true, completion: nil)
    }
    
    func didSelectVehicle(_ controller: showVehicleListViewController, didSelect vehicleNumber: VehicleWiseList) {
        print("Did select Vehicle")
        self.selectedVehicle = vehicleNumber
        updateVehicleName()
    }
//    func didSelectVehicle(vehicleNumber: VehicleWiseList) {
//        print("Did select Vehicle")
//            selectedVehicle = vehicleNumber
//            vehicleNumberLabel.text = vehicleNumber.vehicleNumber
//        updateVehicleName()
//        }
 
        func didSelectDriver(driverName: DriversList) {
            print("Did select Driver")
            selectedDriver = driverName
            driverNameLabel.text = driverName.name
            updateDriverName()
        }

        func updateVehicleName() {
            print("Update the vehicle Name ")

            if let selectedVehicle = selectedVehicle {
                vehicleNumberLabel.text = selectedVehicle.vehicleNumber
            } else {
                vehicleNumberLabel.text = "Select"
            }
            
        }

        func updateDriverName() {
            print("Update the driver name")
            if let selectedDriver = selectedDriver {
                driverNameLabel.text = selectedDriver.name
            } else {
                driverNameLabel.text = "Select"
            }
        }
    
    func presentVehicleList() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vehicleListVC = storyboard.instantiateViewController(withIdentifier: "selectTheVehicle") as! showVehicleListViewController
        let navController = UINavigationController(rootViewController: vehicleListVC)
        vehicleListVC.delegate = self
        present(navController, animated: true, completion: nil)
    }
    func  presentDriverList() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let driverListVC = storyBoard.instantiateViewController(withIdentifier: "selectTheDriver") as! showDriversListViewController
        let navController = UINavigationController(rootViewController: driverListVC)
        driverListVC.title = "Driver List"
        driverListVC.delegate = self
        present(navController, animated: true, completion: nil)
    }
    func updateSaveButtonState() {
           // Enable the save button only if the text field is not empty
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
