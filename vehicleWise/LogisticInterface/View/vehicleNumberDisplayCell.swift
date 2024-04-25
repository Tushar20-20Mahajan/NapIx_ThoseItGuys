//
//  vehicleNumberDisplayCell.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit

class vehicleNumberDisplayCell: UITableViewCell {
    
    @IBOutlet weak var vehicleNumberLable: UILabel!
    @IBOutlet weak var vehicleNumberPlate: UIImageView!

    func updateViewOfVehicleWise(vehicleNumber : VehicleWiseList){
        if let label = vehicleNumberLable {
            label.text = vehicleNumber.vehicleNumber
        }

    }

    

}
