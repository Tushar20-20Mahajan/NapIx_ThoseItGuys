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
    
    func updateViewOfAlertTimmings(alertTimming : AlertTimming){
        alertTimmingsLabel.text = alertTimming.timeAlert
        alertImage.image = UIImage(systemName: alertTimming.iconImage)
    }

}
