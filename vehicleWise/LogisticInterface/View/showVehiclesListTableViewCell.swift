//
//  showVehiclesListTableViewCell.swift
//  vehicleWise
//
//  Created by student on 29/04/24.
//

import UIKit

class showVehiclesListTableViewCell: UITableViewCell {

    @IBOutlet weak var vehicleNumberLable: UILabel!
    @IBOutlet weak var vehicleNumberPlate: UIImageView!

    func updateViewOfVehicleWise(vehicleNumber : VehicleWiseList){
        
        vehicleNumberLable.text = vehicleNumber.vehicleNumber
        vehicleNumberPlate.image = UIImage(systemName:  vehicleNumber.imageNumberPlate)
    }
    

}
