//
//  MyDriversListViewController.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit

class MyDriversListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
   
    
    
    @IBOutlet weak var myDriversList : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myDriversList.dataSource = self
        myDriversList.delegate = self
        myDriversList.register(vehicleNumberDisplayCell.self, forCellReuseIdentifier: "myDriverDetailDisplayCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getDriverList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myDriverDetailDisplayCell", for: indexPath) /*as? vehicleNumberDisplayCell {*/
                let driver = dataModel.getDriverList()[indexPath.row]
                // Configure the cell with the vehicle data
                //cell.updateImageVehiclePlate()
        cell.textLabel?.text = driver.name
        cell.detailTextLabel?.text = driver.mobileNumber
        cell.imageView?.image = driver.imageDriver
                return cell
            
           // return UITableViewCell()
    }
   

    

}
