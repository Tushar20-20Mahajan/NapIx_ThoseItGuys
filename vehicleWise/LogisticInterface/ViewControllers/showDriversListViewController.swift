//
//  showDriversListViewController.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit
protocol SelectDriverNameTableViewControllerDelegate {
    func didSelectDriver(driverName: DriversList)
}
class showDriversListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var showDriverList: UITableView!
    var driverName: DriversList?
        var delegate: SelectDriverNameTableViewControllerDelegate?

        override func viewDidLoad() {
            super.viewDidLoad()

            // Set title for navigation bar
            self.title = "Driver List"

                // Create a "Done" button
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
                self.navigationItem.rightBarButtonItem = doneButton
                doneButton.isEnabled = false // Disable the "Done" button by default

                showDriverList.dataSource = self
                showDriverList.delegate = self
        }
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil) // Dismiss the current view controller
    }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataModel.getDriverList().count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "showDriverListDisplayCell", for: indexPath) as? ShowDriverListTableViewCell {
                let driver = dataModel.getDriverList()[indexPath.row]
                cell.updateDriversView(driver: driver)
                if driver == self.driverName {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                return cell
            }
            return UITableViewCell()
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            driverName = dataModel.getDriverList()[indexPath.row]
            delegate?.didSelectDriver(driverName: driverName!)
            // Enable the "Done" button when a driver is selected
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            tableView.reloadData()
            
        }

     
//    @IBAction func doneButtonTapped(_ sender: Any) {
//        dismiss(animated: true, completion: nil) // Dismiss the current view controller
//    }

}
