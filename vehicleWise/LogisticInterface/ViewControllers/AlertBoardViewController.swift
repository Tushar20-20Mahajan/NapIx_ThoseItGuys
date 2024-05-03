//
//  AlertBoardViewController.swift
//  vehicleWise
//
//  Created by student on 17/04/24.
//

import UIKit

class AlertBoardViewController: UIViewController {
    
    @IBOutlet weak var activeAlerts: UIView!
    @IBOutlet weak var drivingSafely: UIView!
    @IBOutlet weak var scheduled: UIView!
    
    @IBOutlet weak var addnewAlertBtn: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    
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
