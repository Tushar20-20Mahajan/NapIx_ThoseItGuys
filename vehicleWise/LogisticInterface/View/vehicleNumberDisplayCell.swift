//
//  vehicleNumberDisplayCell.swift
//  vehicleWise
//
//  Created by student on 26/04/24.
//

import UIKit

// Custom UITableViewCell class for displaying vehicle number information
class vehicleNumberDisplayCell: UITableViewCell {
    
    // IBOutlet for the vehicle number label
    @IBOutlet weak var vehicleNumberLable: UILabel!
    
    // IBOutlet for the vehicle number plate image view
    @IBOutlet weak var vehicleNumberPlate: UIImageView!

    // Function to update the view of the cell with vehicle-wise information
    func updateViewOfVehicleWise(vehicleNumber: VehicleWiseList) {
        // Set the text of the vehicle number label to the vehicle number
        vehicleNumberLable.text = vehicleNumber.vehicleNumber
        
        // Set the image of the vehicle number plate image view to the system image corresponding to the vehicle number plate
        vehicleNumberPlate.image = UIImage(systemName: vehicleNumber.imageNumberPlate)
    }
}
