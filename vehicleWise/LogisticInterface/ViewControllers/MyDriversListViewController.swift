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
    
   

    @IBAction func addDriversBtnWasPressed(_ sender: Any) {
        print("Btn was Pressed")
        self.performSegue(withIdentifier: "dataPassingFromDriverInformationToMyDrivers", sender: self)
    }
    
    

}
