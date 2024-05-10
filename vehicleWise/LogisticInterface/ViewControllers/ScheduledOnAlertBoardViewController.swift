//
//  ScheduledOnAlertBoardViewController.swift
//  vehicleWise
//
//  Created by student on 28/04/24.
//

import UIKit

class ScheduledOnAlertBoardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddNewScheduleDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var showScheduledList: UITableView!
    
    // MARK: - Properties
    
    var reloadTimer: Timer?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up data source and delegate for the table view
        showScheduledList.dataSource = self
        showScheduledList.delegate = self
        
        // Start reload timer
        startReloadTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload data when the view appears
        showScheduledList.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop the reload timer when the view disappears
        stopReloadTimer()
    }
    
    // MARK: - Timer Methods
    
    // Start the reload timer
    func startReloadTimer() {
        // Timer interval based on whether it's a manual reload or triggered by row deletion
        let timerInterval = reloadTimer == nil ? 15 : 1
        reloadTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timerInterval), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    // Stop the reload timer
    func stopReloadTimer() {
        reloadTimer?.invalidate()
        reloadTimer = nil
    }
    
    // Timer action method to reload table view data
    @objc func timerAction() {
        showScheduledList.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getScheduledAlertOnAlertBoard().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "scheduledAlertBoard") as? ScheduledAlertsTableViewCell {
            let scheduledAlertKeys = Array(dataModel.getScheduledAlertOnAlertBoard().keys)
            let keyAtIndex = scheduledAlertKeys[indexPath.row]
            if let alert = dataModel.getScheduledAlertOnAlertBoard()[keyAtIndex] {
                cell.updateViewOfScheduledAlertBoard(alerts: alert)
            }
            return cell
        }
        return ScheduledAlertsTableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let scheduledAlertKeys = Array(dataModel.getScheduledAlertOnAlertBoard().keys)
            let keyAtIndex = scheduledAlertKeys[indexPath.row]
            if let deletedScheduledRoute = dataModel.removeScheduledRoute(forKey: keyAtIndex) {
                print("Deleted Schedule:", deletedScheduledRoute)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // Restart the reload timer after row deletion
                stopReloadTimer()
                startReloadTimer()
            } else {
                print("Failed to delete scheduled route at index:", indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    // MARK: - AddNewScheduleDelegate
    
    func didAddNewScheduleToRoute() {
        showScheduledList.reloadData()
    }
}
