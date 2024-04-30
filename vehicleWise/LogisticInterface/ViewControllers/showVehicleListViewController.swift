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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
                
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }

}
