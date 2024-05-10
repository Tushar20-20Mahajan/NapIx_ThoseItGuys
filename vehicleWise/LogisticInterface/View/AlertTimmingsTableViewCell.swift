//
//  AlertTimmingsTableViewCell.swift
//  vehicleWise
//
//  Created by student on 30/04/24.
//

import UIKit

// Custom UITableViewCell class for displaying alert timings information
class AlertTimmingsTableViewCell: UITableViewCell {
    
    // IBOutlet for displaying the alert timings label
    @IBOutlet weak var alertTimmingsLabel: UILabel!
    
    // IBOutlet for displaying the image associated with the alert
    @IBOutlet weak var alertImage: UIImageView!
    
    // DateFormatter to format the date
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    // Function to update the view of the cell with alert timings information
    func updateViewOfAlertTimmings(alertTimming: AlertTimming) {
        // Format the date as string for display
        let timeString = dateFormatter.string(from: alertTimming.timeAlert)
        
        // Set the text of the alert timings label to the formatted time string
        alertTimmingsLabel.text = timeString
        
        // Set the image of the alert image view to the image corresponding to the alert
        alertImage.image = UIImage(systemName: alertTimming.iconImage)
    }
}
