//
//  AllertTimmingsViewController.swift
//  vehicleWise
//
//  Created by student on 30/04/24.
//

import UIKit

class AlertTimmingsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var alertTimmingsTable : UITableView!
    @IBOutlet weak var todayDate : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        alertTimmingsTable.dataSource = self
        alertTimmingsTable.delegate = self
        
        let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "dd MMMM yyyy" // Date format: 01 January 2023
               let currentDate = Date()
               let dateString = dateFormatter.string(from: currentDate)
               todayDate.text = dateString
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
                
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    

   

}
