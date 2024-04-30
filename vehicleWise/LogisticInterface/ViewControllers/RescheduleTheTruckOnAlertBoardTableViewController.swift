//
//  RescheduleTheTruckOnAlertBoardTableViewController.swift
//  vehicleWise
//
//  Created by student on 01/05/24.
//

import UIKit

class RescheduleTheTruckOnAlertBoardTableViewController: UITableViewController {

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
    

}
