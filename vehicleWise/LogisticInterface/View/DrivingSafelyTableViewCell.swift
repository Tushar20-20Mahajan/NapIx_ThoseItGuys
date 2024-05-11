//
//  DrivingSafelyTableViewCell.swift
//  vehicleWise
//
//  Created by student on 29/04/24.
//

import UIKit

// Custom UITableViewCell class for displaying driving safely alerts information
class DrivingSafelyTableViewCell: UITableViewCell {
    
    // IBOutlet for displaying the image of the alert type
    @IBOutlet weak var imageAlertType: UIImageView!
    
    // IBOutlet for displaying the route of the alert
    @IBOutlet weak var route: UILabel!
    
    // IBOutlet for displaying the truck number associated with the alert
    @IBOutlet weak var truckNumber: UILabel!
    
    // IBOutlet for displaying the driver name associated with the alert
    @IBOutlet weak var driverName: UILabel!

    // Function to update the view of the cell with driving safely alert information
    func updateViewOfScheduledAlertBoard(alerts: AlertBoardDataDisplayInformation) {
        // Set the image of the alert type image view to the image corresponding to the alert
        imageAlertType.image = UIImage(named: alerts.imageAlert)
        
        // Set the text of the route label to the route of the alert
        route.text = alerts.route
        
        // Set the text of the truck number label to the truck number associated with the alert
        truckNumber.text = alerts.vehicleNumber
        
        // Set the text of the driver name label to the driver name associated with the alert
        driverName.text = alerts.driverName.name
    }

}
