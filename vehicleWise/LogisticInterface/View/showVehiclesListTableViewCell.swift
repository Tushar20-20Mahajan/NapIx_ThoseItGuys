//
//  showVehiclesListTableViewCell.swift
//  vehicleWise
//
//  Created by student on 29/04/24.
//

import UIKit

// Custom UITableViewCell class for displaying vehicle list information
class showVehiclesListTableViewCell: UITableViewCell {

    // IBOutlet for displaying the vehicle number
    @IBOutlet weak var vehicleNumberLable: UILabel!
    
    // IBOutlet for displaying the vehicle number plate image
    @IBOutlet weak var vehicleNumberPlate: UIImageView!

    // Function to update the view of the cell with vehicle-wise information
    func updateViewOfVehicleWise(vehicleNumber: VehicleWiseList) {
        // Set the text of the vehicle number label to the vehicle number
        vehicleNumberLable.text = vehicleNumber.vehicleNumber
        
        // Set the image of the vehicle number plate image view to the system image corresponding to the vehicle number plate
        vehicleNumberPlate.image = UIImage(systemName:  vehicleNumber.imageNumberPlate)
    }
}
