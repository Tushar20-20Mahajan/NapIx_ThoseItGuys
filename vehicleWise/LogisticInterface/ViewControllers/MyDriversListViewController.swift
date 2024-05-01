//
//  MyDriversListViewController.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit

class MyDriversListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate  , AddDriversDelegate {
   
    
    
    @IBOutlet weak var myDriversList : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myDriversList.dataSource = self
        myDriversList.delegate = self
        self.myDriversList.reloadData()
       
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        didAddNewDriver()
           myDriversList.reloadData()
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the driver at the specified index
            if let deletedDriver = dataModel.removeDriver(at: indexPath.row) {
                // Optionally, perform any additional actions related to the deleted driver
                print("Deleted driver:", deletedDriver)

                // Perform deletion from table view
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                print("Failed to delete driver at index:", indexPath.row)
            }
        }
    }


    
    func didAddNewDriver() {
        myDriversList.reloadData()
        }
   

    @IBAction func addDriversBtnWasPressed(_ sender: Any) {
        print("Btn was Pressed")
       
    }
    
    

}
