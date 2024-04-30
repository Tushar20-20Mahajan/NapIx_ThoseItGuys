//
//  AddDriversDataTableViewController.swift
//  vehicleWise
//
//  Created by student on 01/05/24.
//

import UIKit

class AddDriversDataTableViewController: UITableViewController {
    @IBOutlet weak var driverNameTextFeild: UITextField!
    
    @IBOutlet weak var driverMobileNumberTextFeild: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

   
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveDataBtnWasPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "dataPassingFromDriverInformationToMyDrivers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dataPassingFromDriverInformationToMyDrivers"{
            if let datatoBePassed = segue.destination as? MyDriversListViewController{
                
            }
        }
    }
}
