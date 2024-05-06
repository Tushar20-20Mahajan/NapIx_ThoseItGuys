//
//  AlertBoardViewController.swift
//  vehicleWise
//
//  Created by student on 17/04/24.
//

import UIKit

class AlertBoardViewController: UIViewController/* ,  UISearchBarDelegate*/{
    
    @IBOutlet weak var activeAlerts: UIView!
    @IBOutlet weak var drivingSafely: UIView!
    @IBOutlet weak var scheduled: UIView!
    
    @IBOutlet weak var addnewAlertBtn: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        
//        // Add a gesture recognizer to dismiss the keyboard when tapping anywhere else on the screen
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tapGesture)
    }
//    // Method to dismiss the keyboard when tapping anywhere else on the screen
//       @objc func dismissKeyboard() {
//           view.endEditing(true)
//       }
//    // UISearchBarDelegate method to dismiss the keyboard when search button is clicked
//        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//            searchBar.resignFirstResponder()
//        }
    
    @IBAction func switchViewsofAlertBoard(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            activeAlerts.alpha = 1
            drivingSafely.alpha = 0
            scheduled.alpha = 0
        }else if (sender.selectedSegmentIndex == 1){
            activeAlerts.alpha = 0
            drivingSafely.alpha = 1
            scheduled.alpha = 0
        }else if (sender.selectedSegmentIndex == 2){
            activeAlerts.alpha = 0
            drivingSafely.alpha = 0
            scheduled.alpha = 1
            
        }
    }
    

    @IBAction func addNewTruckToTheRouteWasPressed(_ sender: Any) {
    }
    

}
