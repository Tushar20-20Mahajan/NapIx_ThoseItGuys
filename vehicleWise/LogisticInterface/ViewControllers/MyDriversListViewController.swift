//
//  MyDriversListViewController.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit

class MyDriversListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate  , AddDriversDelegate {
   
    
    
    @IBOutlet weak var myDriversList : UITableView!

    var reloadTimer: Timer?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            myDriversList.dataSource = self
            myDriversList.delegate = self
            startReloadTimer() // Start the timer when the view loads
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
            let timerInterval = reloadTimer == nil ? 10 : 1
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
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataModel.getDriverList().count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "myDriverDetailDisplayCell") as? MyDriversDisplayTableViewCell{
                let driver = dataModel.getDriverList()[indexPath.row]
                cell.updateDriversView(driver: driver)
                return cell
            }
            return MyDriversDisplayTableViewCell()
        }
        
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
        
        func didAddNewDriver() {
            myDriversList.reloadData()
        }

    @IBAction func addDriversBtnWasPressed(_ sender: Any) {
        print("Btn was Pressed")
       
    }
    
   

}

