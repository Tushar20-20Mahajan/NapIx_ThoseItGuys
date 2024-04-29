//
//  showVehicleListViewController.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit

class showVehicleListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    
    @IBOutlet weak var showVehicleList : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showVehicleList.dataSource = self
        showVehicleList.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getVehicleList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "showVehicleListDisplayCell") as? showVehiclesListTableViewCell else {
            return UITableViewCell()
        }

        let vehicle = dataModel.getVehicleList()[indexPath.row]
        // Configure the cell with the vehicle data
        cell.updateViewOfVehicleWise(vehicleNumber: vehicle)

        return cell
                
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
