//
//  DrivingSafelyOnAlertBoardViewController.swift
//  vehicleWise
//
//  Created by student on 28/04/24.
//

import UIKit

class DrivingSafelyOnAlertBoardViewController: UIViewController  ,UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var showSafelyDrivingList : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       showSafelyDrivingList.dataSource = self
        showSafelyDrivingList.delegate = self
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getDrivingSafelyAlertOnAlertBoard().count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "drivingSafelyAlertBoard") as? DrivingSafelyTableViewCell{
            let alerts = dataModel.getDrivingSafelyAlertOnAlertBoard()[indexPath.row]
            
            cell.updateViewOfScheduledAlertBoard(alerts: alerts)
            
            return cell
        }
        return ScheduledAlertsTableViewCell()
    }

}
