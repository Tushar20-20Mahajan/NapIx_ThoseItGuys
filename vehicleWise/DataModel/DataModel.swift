//
//  DataModel.swift
//  vehicleWise
//
//  Created by student on 18/04/24.
//

import Foundation
import UIKit


// VehicleWise Profile
struct Profile{
    var image: UIImage
    var title: String
}

struct Drivers{
    var name: String
    var mobile: String
    var image: String
}




class DataModel{
    var profilesSectionOne : [Profile] = [
        Profile(image: UIImage(systemName: "person.text.rectangle")!, title: "Personal Information"),
        Profile(image: UIImage(systemName: "figure.seated.seatbelt")!, title: "My Drivers"),
        Profile(image: UIImage(systemName: "questionmark.circle")!, title: "Help"),
        Profile(image: UIImage(systemName: "list.bullet.clipboard")!, title: "Privacy Policy")
    ]
}
