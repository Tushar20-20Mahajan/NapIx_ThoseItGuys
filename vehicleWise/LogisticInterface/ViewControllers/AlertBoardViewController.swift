//
//  AlertBoardViewController.swift
//  vehicleWise
//
//  Created by student on 17/04/24.
//

import UIKit

@available(iOS 16.4, *)
class AlertBoardViewController: UIViewController/* ,  UISearchBarDelegate*/{
    
    // MARK: - Outlets
    
    @IBOutlet weak var activeAlerts: UIView!
    @IBOutlet weak var drivingSafely: UIView!
    @IBOutlet weak var scheduled: UIView!
    
    @IBOutlet weak var addnewAlertBtn: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the back button in the navigation bar
        navigationItem.hidesBackButton = true
        
        // Disable the search bar by default
        searchBar.isEnabled = false
        
        // Do any additional setup after loading the view.
        
        // Commented out gesture recognizer to dismiss the keyboard
        // Add a gesture recognizer to dismiss the keyboard when tapping anywhere else on the screen
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    // Method to switch between different views of the alert board based on the segmented control selection
    @IBAction func switchViewsofAlertBoard(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            activeAlerts.alpha = 1
            drivingSafely.alpha = 0
            scheduled.alpha = 0
        } else if (sender.selectedSegmentIndex == 1) {
            activeAlerts.alpha = 0
            drivingSafely.alpha = 1
            scheduled.alpha = 0
        } else if (sender.selectedSegmentIndex == 2) {
            activeAlerts.alpha = 0
            drivingSafely.alpha = 0
            scheduled.alpha = 1
        }
    }

    // MARK: - IBActions
    
    // IBAction method triggered when the "Add New Truck to the Route" button is pressed
    @IBAction func addNewTruckToTheRouteWasPressed(_ sender: Any) {
        // Implement the action for adding a new truck to the route
    }
    
    // MARK: - Other Methods
    
    // Method to dismiss the keyboard when tapping anywhere else on the screen
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    // UISearchBarDelegate method to dismiss the keyboard when search button is clicked
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
}
