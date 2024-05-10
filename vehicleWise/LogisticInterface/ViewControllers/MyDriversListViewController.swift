//
//  MyDriversListViewController.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit

// ViewController to display the list of drivers
class MyDriversListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddDriversDelegate, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var myDriversList: UITableView!
    
    // MARK: - Properties
    
    var reloadTimer: Timer? // Timer to reload the data periodically
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the table view data source and delegate
        myDriversList.dataSource = self
        myDriversList.delegate = self
        
        startReloadTimer() // Start the timer to reload the data periodically
        
        // Add a gesture recognizer to dismiss the keyboard when tapping anywhere else on the screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // Method to dismiss the keyboard when tapping anywhere else on the screen
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // UISearchBarDelegate method to dismiss the keyboard when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh the data when the view appears
        myDriversList.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopReloadTimer() // Stop the timer when the view disappears
    }
    
    // Method to start the timer
    func startReloadTimer() {
        // Timer interval based on whether it's a manual reload or triggered by row deletion
        let timerInterval = reloadTimer == nil ? 15 : 0.5
        reloadTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timerInterval), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    // Method to stop the timer
    func stopReloadTimer() {
        reloadTimer?.invalidate()
        reloadTimer = nil
    }
    
    // Timer action method
    @objc func timerAction() {
        // Reload the table view data
        myDriversList.reloadData()
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getDriverList().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell with driver data
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myDriverDetailDisplayCell") as? MyDriversDisplayTableViewCell {
            let driver = dataModel.getDriverList()[indexPath.row]
            cell.updateDriversView(driver: driver)
            return cell
        }
        return MyDriversDisplayTableViewCell() // Return a default cell if configuration fails
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let deletedDriver = dataModel.removeDriver(at: indexPath.row) {
                print("Deleted driver:", deletedDriver)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // Restart the reload timer after row deletion
                stopReloadTimer()
                startReloadTimer()
            } else {
                print("Failed to delete driver at index:", indexPath.row)
            }
        }
    }
    
    // MARK: - AddDriversDelegate Method
    
    // Method called when a new driver is added
    func didAddNewDriver() {
        myDriversList.reloadData() // Reload the table view data
    }

    // MARK: - IBActions
    
    // Action method for adding drivers
    @IBAction func addDriversBtnWasPressed(_ sender: Any) {
        print("Btn was Pressed")
    }
}
