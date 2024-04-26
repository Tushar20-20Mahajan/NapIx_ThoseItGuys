//
//  showDriversListViewController.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit

class showDriversListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var showDriverList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showDriverList.dataSource = self
        showDriverList.delegate = self
        showDriverList.register(vehicleNumberDisplayCell.self, forCellReuseIdentifier: "shwoDriverListDisplayCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getDriverList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shwoDriverListDisplayCell", for: indexPath) /*as? vehicleNumberDisplayCell {*/
                let driver = dataModel.getDriverList()[indexPath.row]
                // Configure the cell with the vehicle data
                //cell.updateImageVehiclePlate()
        cell.textLabel?.text = driver.name
        cell.detailTextLabel?.text = driver.mobileNumber
        cell.imageView?.image = driver.imageDriver
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
