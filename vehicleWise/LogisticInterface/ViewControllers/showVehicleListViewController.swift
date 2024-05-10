//
//  showVehicleListViewController.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit

// Protocol to delegate the selection of a vehicle number
protocol SelectVehicleNumberTableViewControllerDelegate {
    func didSelectVehicle(_ controller: showVehicleListViewController, didSelect vehicleNumber: VehicleWiseList)
}

class showVehicleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var showVehicleList: UITableView!
    
    // MARK: - Properties
    
    var vehicleName: VehicleWiseList? // Currently selected vehicle
    var delegate: SelectVehicleNumberTableViewControllerDelegate? // Delegate to communicate back the selected vehicle
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title for the view controller
        self.title = "Vehicle List"
        
        // Create a "Done" button in the navigation bar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = doneButton
        doneButton.isEnabled = false // Disable the "Done" button by default
        
        // Set the data source and delegate for the table view
        showVehicleList.dataSource = self
        showVehicleList.delegate = self
    }
    
    // MARK: - IBActions
    
    // Action method for the "Done" button
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil) // Dismiss the current view controller
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getVehicleList().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "showVehicleListDisplayCell", for: indexPath) as? showVehiclesListTableViewCell else {
            return UITableViewCell()
        }

        let vehicle = dataModel.getVehicleList()[indexPath.row]
        cell.updateViewOfVehicleWise(vehicleNumber: vehicle)

        // Configure cell accessory based on the selected vehicle
        if vehicle == self.vehicleName {
            cell.accessoryType = .checkmark // Display checkmark if the vehicle is selected
        } else {
            cell.accessoryType = .none // Remove checkmark if the vehicle is not selected
        }

        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Update the selected vehicle
        vehicleName = dataModel.getVehicleList()[indexPath.row]
        
        // Notify the delegate about the selected vehicle
        delegate?.didSelectVehicle(self, didSelect: vehicleName!)
        
        // Enable the "Done" button when a vehicle is selected
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        // Reload the table view to reflect the updated selection
        tableView.reloadData()
    }
}
