//
//  AddVehicleDataTableViewController.swift
//  vehicleWise
//
//  Created by student on 02/05/24.
//

import UIKit

class AddVehicleDataTableViewController: UITableViewController {

    @IBOutlet weak var vehicleNumberTextFeild: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
