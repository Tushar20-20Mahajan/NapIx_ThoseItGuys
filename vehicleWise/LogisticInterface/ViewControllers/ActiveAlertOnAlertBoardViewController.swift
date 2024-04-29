//
//  ActiveAlertOnAlertBoardViewController.swift
//  vehicleWise
//
//  Created by student on 28/04/24.
//

import UIKit

class ActiveAlertOnAlertBoardViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    

    @IBOutlet weak var showActiveAlertList : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showActiveAlertList.delegate = self
        showActiveAlertList.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getActiveAlertOnAlertBoard().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "activeAlertsOnAlertBoard") as? ActiveAlertTableViewCell{
            
            let alerts = dataModel.getActiveAlertOnAlertBoard()[indexPath.row]
            
            cell.updateViewOfScheduledAlertBoard(alerts: alerts)
            
            return cell
        }
        return ScheduledAlertsTableViewCell()
    }
    


}
