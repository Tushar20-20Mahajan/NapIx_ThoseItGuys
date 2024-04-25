//
//  VehicleListViewController.swift
//  vehicleWise
//
//  Created by student on 17/04/24.
//

import UIKit
import Foundation

class VehicleListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    
    

    @IBOutlet weak var vehicleNumberList : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vehicleNumberList.dataSource = self
        vehicleNumberList.delegate = self
        vehicleNumberList.register(vehicleNumberDisplayCell.self, forCellReuseIdentifier: "vehicleWiseDisplayCell")

        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getVehicleList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vehicleWiseDisplayCell", for: indexPath) /*as? vehicleNumberDisplayCell {*/
                let vehicle = dataModel.getVehicleList()[indexPath.row]
                // Configure the cell with the vehicle data
                //cell.updateImageVehiclePlate()
        cell.textLabel?.text = vehicle.vehicleNumber
        cell.imageView?.image = vehicle.imageNumberPlate
                return cell
            
           // return UITableViewCell()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
