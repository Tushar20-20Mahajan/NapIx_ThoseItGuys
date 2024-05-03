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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        vehicleNumberList.dataSource = self
        vehicleNumberList.delegate = self
        
       // self.vehicleNumberList.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        vehicleNumberList.reloadData()
 //       self.reloadInputViews()
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
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        
        //                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the driver at the specified index
            if let deletedDriver = dataModel.removeVehicle(at: indexPath.row) {
                // Optionally, perform any additional actions related to the deleted driver
                print("Deleted driver:", deletedDriver)

                // Perform deletion from table view
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                print("Failed to delete driver at index:", indexPath.row)
            }
        }
    }

    
    @IBAction func addNewVehicleBtnWasPressed(_ sender: Any) {
        
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
