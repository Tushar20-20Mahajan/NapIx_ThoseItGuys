//
//  VehicleListViewController.swift
//  vehicleWise
//
//  Created by student on 17/04/24.
//

import UIKit
import Foundation

class VehicleListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , AddVehicleDelegate{
    
    
    
    @IBOutlet weak var vehicleNumberList : UITableView!
    var newVehicle: VehicleWiseList?
        var reloadTimer: Timer?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            vehicleNumberList.dataSource = self
            vehicleNumberList.delegate = self
            
            startReloadTimer() // Start the timer when the view loads
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // Refresh the data when the view appears
            vehicleNumberList.reloadData()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            stopReloadTimer() // Stop the timer when the view disappears
        }
        
        // Method to start the timer
        func startReloadTimer() {
            // Timer interval based on whether it's a manual reload or triggered by row deletion
            let timerInterval = reloadTimer == nil ? 15 : 1
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
            vehicleNumberList.reloadData()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataModel.getVehicleList().count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "vehicleNumberDisplayCell") as? vehicleNumberDisplayCell else {
                return UITableViewCell()
            }
            
            let vehicle = dataModel.getVehicleList()[indexPath.row]
            // Configure the cell with the vehicle data
            cell.updateViewOfVehicleWise(vehicleNumber: vehicle)
            
            return cell
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
                if let deletedVehicle = dataModel.removeVehicle(at: indexPath.row) {
                    print("Deleted Vehicle:", deletedVehicle)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    // Restart the reload timer after row deletion
                    stopReloadTimer()
                    startReloadTimer()
                } else {
                    print("Failed to delete vehicle at index:", indexPath.row)
                }
            }
        }
    @IBAction func addNewVehicleBtnWasPressed(_ sender: Any) {
        print("Add btn was pressed")
        
    }
    
    func didAddNewVehicle() {
        vehicleNumberList.reloadData()
    }
    
    
//   @IBAction func unwindtoVehicleList(unwindSegue : UIStoryboardSegue){
//       if unwindSegue.source is AddVehicleDataTableViewController {
//                   // Reload data to reflect the updated vehicle list
//                   vehicleNumberList.reloadData()
//               }
//        
//    }
}
