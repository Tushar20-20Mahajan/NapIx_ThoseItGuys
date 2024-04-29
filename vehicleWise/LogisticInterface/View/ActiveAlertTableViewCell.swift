//
//  ActiveAlertTableViewCell.swift
//  vehicleWise
//
//  Created by student on 29/04/24.
//

import UIKit

class ActiveAlertTableViewCell: UITableViewCell {

    @IBOutlet weak var imageAlertType : UIImageView!
    @IBOutlet weak var route : UILabel!
    @IBOutlet weak var truckNumber : UILabel!
    @IBOutlet weak var driverName : UILabel!

    func updateViewOfScheduledAlertBoard(alerts :AlertBoardDataDisplayInformation){
        imageAlertType.image = UIImage(named: alerts.imageAlert)
        route.text = alerts.route
        truckNumber.text = alerts.vehicleNumber
        driverName.text = alerts.driverName
    }
    

}
