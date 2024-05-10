import UIKit

class ActiveAlertOnAlertBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets
    @IBOutlet weak var showActiveAlertList: UITableView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the delegate and data source for the table view
        showActiveAlertList.delegate = self
        showActiveAlertList.dataSource = self
    }
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of active alerts in the data model
        return dataModel.getActiveAlertOnAlertBoard().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "activeAlertsOnAlertBoard") as? ActiveAlertTableViewCell {
            // Get the active alert at the current index path
            let alerts = Array(dataModel.getActiveAlertOnAlertBoard().values)[indexPath.row]
            
            // Update the cell with the active alert information
            cell.updateViewOfScheduledAlertBoard(alerts: alerts)
            
            return cell
        }
        // If no reusable cell is available, return a default cell
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row when tapped
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Deselect the row when tapped
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
