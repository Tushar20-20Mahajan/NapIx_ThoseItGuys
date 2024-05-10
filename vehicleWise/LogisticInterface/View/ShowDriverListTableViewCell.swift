//
//  ShowDriverListTableViewCell.swift
//  vehicleWise
//
//  Created by student on 30/04/24.
//

import UIKit

// Custom UITableViewCell class for displaying driver list information
class ShowDriverListTableViewCell: UITableViewCell {

    // IBOutlet for displaying the driver's name
    @IBOutlet weak var driverName: UILabel!
    
    // IBOutlet for displaying the driver's phone number
    @IBOutlet weak var driverPhoneNumber: UILabel!
    
    // IBOutlet for displaying the driver's icon image
    @IBOutlet weak var imkageIcon: UIImageView!
    
    // Function to update the view of the cell with driver information
    func updateDriversView(driver: DriversList) {
        // Set the text of the driver's name label to the driver's name
        driverName.text = driver.name
        
        // Set the text of the driver's phone number label to the driver's phone number
        driverPhoneNumber.text = driver.mobileNumber
        
        // Set the image of the driver's icon image view to the system image corresponding to the driver's icon
        imkageIcon.image = UIImage(systemName: driver.imageDriver)
    }

}
