//
//  MyDriversDisplayTableViewCell.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit

class MyDriversDisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverPhoneNumber : UILabel!
    @IBOutlet weak var imkageIcon : UIImageView!
    
    func updateDriversView(driver : DriversList){
        driverName.text = driver.name
        driverPhoneNumber.text = driver.mobileNumber
        imkageIcon.image = UIImage(systemName: driver.imageDriver)
    }
    

}
