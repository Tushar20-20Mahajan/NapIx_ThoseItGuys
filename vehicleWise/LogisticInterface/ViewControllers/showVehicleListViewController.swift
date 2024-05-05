//
//  showVehicleListViewController.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit
protocol SelectVehicleNumberTableViewControllerDelegate {
    func didSelectVehicle(_ controller : showVehicleListViewController , didSelect vehicleNumber: VehicleWiseList)
}

class showVehicleListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    
    
    @IBOutlet weak var showVehicleList : UITableView!
    var vehicleName: VehicleWiseList?
       var delegate: SelectVehicleNumberTableViewControllerDelegate?
    

       override func viewDidLoad() {
           super.viewDidLoad()
           
           self.title = "Vehicle List"

               // Create a "Done" button
               let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
               self.navigationItem.rightBarButtonItem = doneButton
               doneButton.isEnabled = false // Disable the "Done" button by default
           showVehicleList.dataSource = self
           showVehicleList.delegate = self
           
       }
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil) // Dismiss the current view controller
    }
    

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return dataModel.getVehicleList().count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "showVehicleListDisplayCell", for: indexPath) as? showVehiclesListTableViewCell else {
               return UITableViewCell()
           }

           let vehicle = dataModel.getVehicleList()[indexPath.row]
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
        delegate?.didSelectVehicle(self, didSelect: vehicleName!)
        // Enable the "Done" button when a driver is selected
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        tableView.reloadData()
        
    }

   
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showNewAlertViewController", // Check if the segue identifier matches
//           let destinationVC = segue.destination as? NewAlertTableViewController {
//            destinationVC.selectedVehicle = vehicleName // Pass the selected vehicle to NewAlertTableViewController
//        }
//    }
    
    

}
