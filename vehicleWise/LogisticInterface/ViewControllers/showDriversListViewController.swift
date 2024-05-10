//
//  showDriversListViewController.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit

// Protocol to notify the delegate when a driver is selected
protocol SelectDriverNameTableViewControllerDelegate {
    func didSelectDriver(driverName: DriversList)
}

// View controller for displaying a list of drivers
class showDriversListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var showDriverList: UITableView!
    
    // MARK: - Properties
    
    var driverName: DriversList? // Currently selected driver
    var delegate: SelectDriverNameTableViewControllerDelegate? // Delegate to notify about selected driver
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title for navigation bar
        self.title = "Driver List"
        
        // Create a "Done" button for navigation bar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = doneButton
        doneButton.isEnabled = false // Disable the "Done" button by default
        
        // Set data source and delegate for the table view
        showDriverList.dataSource = self
        showDriverList.delegate = self
    }
    
    // MARK: - Helper Methods
    
    // Action method for tapping the "Done" button
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil) // Dismiss the current view controller
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getDriverList().count // Return the number of drivers in the data model
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "showDriverListDisplayCell", for: indexPath) as? ShowDriverListTableViewCell {
            let driver = dataModel.getDriverList()[indexPath.row] // Get the driver at the current index
            cell.updateDriversView(driver: driver) // Update the cell with driver information
            
            // Set checkmark accessory if the driver matches the currently selected driver
            if driver == self.driverName {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
        return UITableViewCell() // Return a default cell if unable to dequeue reusable cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Deselect the row after selection
        driverName = dataModel.getDriverList()[indexPath.row] // Update the currently selected driver
        delegate?.didSelectDriver(driverName: driverName!) // Notify the delegate about the selected driver
        
        // Enable the "Done" button when a driver is selected
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        tableView.reloadData() // Reload the table view to update cell appearance
    }
}

