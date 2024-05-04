//
//  showDriversListViewController.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit
protocol SelectDriverNameTableViewControllerDelegate {
    func didSelectDriver(driverName: DriversList)
}
class showDriversListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var showDriverList: UITableView!
    var driverName: DriversList?
        var delegate: SelectDriverNameTableViewControllerDelegate?
        

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showDriverList.dataSource = self
        showDriverList.delegate = self
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getDriverList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "showDriverListDisplayCell") as? ShowDriverListTableViewCell{
            let driver = dataModel.getDriverList()[indexPath.row]
            cell.updateDriversView(driver: driver)
            if driver == self.driverName {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
            
        }
                return ShowDriverListTableViewCell()
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        driverName = dataModel.getDriverList()[indexPath.row]
        delegate?.didSelectDriver(driverName: driverName!)
        tableView.reloadData()
    }
    
    

}
