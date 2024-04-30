//
//  AllertTimmingsViewController.swift
//  vehicleWise
//
//  Created by student on 30/04/24.
//

import UIKit

class AlertTimmingsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var alertTimmingsTable : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        alertTimmingsTable.dataSource = self
        alertTimmingsTable.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getAlertTimmingsOnAlertBoard().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "alertTimmingsCell") as? AlertTimmingsTableViewCell{
            let timmings = dataModel.getAlertTimmingsOnAlertBoard()[indexPath.row]
            
            cell.updateViewOfAlertTimmings(alertTimming: timmings)
            
            return cell
        }
        return AlertTimmingsTableViewCell()
    }
    

   

}
