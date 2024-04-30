//
//  AllertTimmingsTableViewCell.swift
//  vehicleWise
//
//  Created by student on 30/04/24.
//

import UIKit

class AlertTimmingsTableViewCell: UITableViewCell {

    @IBOutlet weak var alertTimmingsLabel : UILabel!
    @IBOutlet weak var alertImage : UIImageView!
    
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter
        }()
        
        func updateViewOfAlertTimmings(alertTimming: AlertTimming) {
            // Format the date as string for display
            let timeString = dateFormatter.string(from: alertTimming.timeAlert)
            
            alertTimmingsLabel.text = timeString
            alertImage.image = UIImage(systemName: alertTimming.iconImage)
        }

}
