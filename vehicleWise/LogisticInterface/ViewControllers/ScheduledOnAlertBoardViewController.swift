//
//  ScheduledOnAlertBoardViewController.swift
//  vehicleWise
//
//  Created by student on 28/04/24.
//

import UIKit

class ScheduledOnAlertBoardViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , AddNewScheduleDelegate{
    
    
    

    @IBOutlet weak var showScheduledList : UITableView!
    var reloadTimer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showScheduledList.dataSource = self
        showScheduledList.delegate = self
        
        startReloadTimer()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showScheduledList.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopReloadTimer() // Stop the timer when the view disappears
    }
    
    
    // Method to start the timer
    func startReloadTimer() {
        // Timer interval based on whether it's a manual reload or triggered by row deletion
        let timerInterval = reloadTimer == nil ? 15 : 1
        reloadTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timerInterval), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    // Method to stop the timer
    func stopReloadTimer() {
        reloadTimer?.invalidate()
        reloadTimer = nil
    }
    
    // Timer action method
    @objc func timerAction() {
        // Reload the table view data
        showScheduledList.reloadData()
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
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let deletedScheduledRoute = dataModel.removeVehicle(at: indexPath.row) {
                print("Deleted Schedule:", deletedScheduledRoute)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // Restart the reload timer after row deletion
                stopReloadTimer()
                startReloadTimer()
            } else {
                print("Failed to delete vehicle at index:", indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
    }
    func didAddNewScheduleToRoute() {
        showScheduledList.reloadData()
    }
   
    
}
