import UIKit

class DrivingSafelyOnAlertBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var showSafelyDrivingList: UITableView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the delegate and data source for the table view
        showSafelyDrivingList.dataSource = self
        showSafelyDrivingList.delegate = self
    }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of driving safely alerts in the data model
        return dataModel.getDrivingSafelyAlertOnAlertBoard().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "drivingSafelyAlertBoard") as? DrivingSafelyTableViewCell {
            // Get the driving safely alert at the current index path
            let alerts = Array(dataModel.getDrivingSafelyAlertOnAlertBoard().values)[indexPath.row]

            // Update the cell with the driving safely alert information
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
