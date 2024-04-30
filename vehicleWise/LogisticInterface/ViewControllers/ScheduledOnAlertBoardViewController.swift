//
//  ScheduledOnAlertBoardViewController.swift
//  vehicleWise
//
//  Created by student on 28/04/24.
//

import UIKit

class ScheduledOnAlertBoardViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    
    

    @IBOutlet weak var showScheduledList : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showScheduledList.dataSource = self
        showScheduledList.delegate = self

    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getScheduledAlertOnAlertBoard().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "scheduledAlertBoard") as? ScheduledAlertsTableViewCell{
            let alerts = dataModel.getScheduledAlertOnAlertBoard()[indexPath.row]
            
            cell.updateViewOfScheduledAlertBoard(alerts: alerts)
            
            return cell
        }
        return ScheduledAlertsTableViewCell()
    }

}