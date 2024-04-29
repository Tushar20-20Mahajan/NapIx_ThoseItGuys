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
        //        if let label = vehicleNumberLable {
        //            label.text = vehicleNumber.vehicleNumber
        //        }
        
        vehicleNumberLable.text = vehicleNumber.vehicleNumber
        vehicleNumberPlate.image = UIImage(named: vehicleNumber.imageNumberPlate)
    }
    

}
