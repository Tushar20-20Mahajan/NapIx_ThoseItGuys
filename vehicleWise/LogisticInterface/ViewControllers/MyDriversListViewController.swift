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
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getDriverList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myDriverDetailDisplayCell") as? MyDriversDisplayTableViewCell{
            let driver = dataModel.getDriverList()[indexPath.row]
            // Configure the cell with the vehicle data
    cell.updateDriversView(driver: driver)

            return cell
            
        }
                
            
            return MyDriversDisplayTableViewCell()
    }
   

    

}
