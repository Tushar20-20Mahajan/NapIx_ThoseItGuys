//
//  AlertTimmingsViewController.swift
//  vehicleWise
//
//  Created by student on 30/04/24.
//

import UIKit

// View controller for displaying alert timings
class AlertTimmingsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var alertTimmingsTable : UITableView! // Table view to display alert timings
    @IBOutlet weak var todayDate : UILabel! // Label to display the current date
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view data source and delegate
        alertTimmingsTable.dataSource = self
        alertTimmingsTable.delegate = self
        
        // Set the current date in the "todayDate" label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy" // Date format: 01 January 2023
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        todayDate.text = dateString
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getAlertTimmingsOnAlertBoard().count // Return the number of alert timings
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "alertTimmingsCell") as? AlertTimmingsTableViewCell {
            let timmings = dataModel.getAlertTimmingsOnAlertBoard()[indexPath.row] // Get alert timings at the current index
            
            // Update the cell with alert timings information
            cell.updateViewOfAlertTimmings(alertTimming: timmings)
            
            return cell
        }
        return AlertTimmingsTableViewCell() // Return a default cell if unable to dequeue reusable cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Deselect the row after selection
        
        // Deselect the selected row programmatically
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Deselect the row after selection
    }
}

