//
//  showVehicleListViewController.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit
protocol SelectVehicleNumberTableViewControllerDelegate {
    func didSelectVehicle(vehicleNumber: VehicleWiseList)
}

class showVehicleListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var showVehicleList : UITableView!
    var vehicleName: VehicleWiseList?
        var delegate: SelectVehicleNumberTableViewControllerDelegate?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            showVehicleList.dataSource = self
            showVehicleList.delegate = self
            doneButton.isEnabled = false // Initially disable the "Done" button
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataModel.getVehicleList().count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "showVehicleListDisplayCell") as? showVehiclesListTableViewCell else {
                return UITableViewCell()
            }
            
            let vehicle = dataModel.getVehicleList()[indexPath.row]
            // Configure the cell with the vehicle data
            cell.updateViewOfVehicleWise(vehicleNumber: vehicle)
            
            if vehicle == self.vehicleName {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            vehicleName = dataModel.getVehicleList()[indexPath.row]
            delegate?.didSelectVehicle(vehicleNumber: vehicleName!)
            tableView.reloadData()
            doneButton.isEnabled = true // Enable the "Done" button when a row is selected
        }
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil) // Dismiss the current view controller
    }
}
