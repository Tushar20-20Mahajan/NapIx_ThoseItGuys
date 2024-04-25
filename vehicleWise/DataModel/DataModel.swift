//
//  DataModel.swift
//  vehicleWise
//
//  Created by student on 18/04/24.
//

import Foundation
import UIKit



struct Users{
    var Logistics: String
    var name: String
    var email: String?
    var mobileNumber: String?
}


struct DriversList : Equatable , Comparable{
    var name: String
    var mobileNumber: String
    static func ==(lhs: DriversList, rhs: DriversList) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    static func <(lhs: DriversList, rhs: DriversList) -> Bool {
        return lhs.name < rhs.name
    }
}

struct VehicleWiseList : Equatable , Comparable{
    var vehicleNumber : String
    // Implementing Equatable protocol
        static func ==(lhs: VehicleWiseList, rhs: VehicleWiseList) -> Bool {
            return lhs.vehicleNumber == rhs.vehicleNumber
        }
        
        // Implementing Comparable protocol for sorting
        static func <(lhs: VehicleWiseList, rhs: VehicleWiseList) -> Bool {
            return lhs.vehicleNumber < rhs.vehicleNumber
        }
    
}


struct AlertBoardDataDisplayInformation {
    var imageAlert : String
    var route: String
    var vehicleNumber : String
    var driverName : String
}

struct AlertTimming {
    var iconImage : UIImage?
    var timeAlert : Date?
    var dateAlert : Date?
}


struct ScheduleRoute{
    var vehicleNumber :String
    var driverName : String
    
    var fromLocation : String
    var toLocation : String
    
    var departureDetails : Date?
}

struct VehicleNumberSelection: Equatable {
    static func ==(lhs: VehicleNumberSelection, rhs: VehicleNumberSelection) -> Bool {
        return lhs.vehicleNumber == rhs.vehicleNumber
    }
    
    var vehicleNumber: String
    private static let dataModel = DataModel()  // Instance of DataModel
    
    static var all: [VehicleWiseList] {
        return dataModel.getVehicleList()  // Fetch vehicle list from DataModel
    }
}

struct DriverNameSelection: Equatable {
    static func ==(lhs: DriverNameSelection, rhs: DriverNameSelection) -> Bool {
        return lhs.driverName == rhs.driverName && lhs.mobileNumber == rhs.mobileNumber
    }
    
    var driverName: String
    var mobileNumber: String
    private static let dataModel = DataModel()  // Instance of DataModel
    
    static var all: [DriversList] {
        return dataModel.getDriverList()  // Fetch driver list from DataModel
    }
}





class DataModel{
    
    private var vehicleList : [VehicleWiseList] = [
        VehicleWiseList(vehicleNumber: "NYC 7777"),
        VehicleWiseList(vehicleNumber: "GJZ 0196"),
        VehicleWiseList(vehicleNumber: "NYC 8910"),
        VehicleWiseList(vehicleNumber: "CAl 8910"),
        VehicleWiseList(vehicleNumber: "WAS 8910"),
        VehicleWiseList(vehicleNumber: "AZM 8910"),
        VehicleWiseList(vehicleNumber: "SAM 8910")
    ]
    
    func getVehicleList() -> [VehicleWiseList] {
        return vehicleList.sorted()
    }
    func addVehicleToVehicleList(newVehicle : VehicleWiseList){
        vehicleList.insert(newVehicle, at: 0)
        vehicleList.sort()
    }
    
    private var driverDetailList : [DriversList] = [
        DriversList(name: "Tushar Mahajan", mobileNumber: "+1(654) 559-5290"),
        DriversList(name: "Utsav Sharma", mobileNumber: "+1(654) 559-5290"),
        DriversList(name: "Sunidhi Ratra", mobileNumber: "+1(654) 559-5290"),
        DriversList(name: "Ritik Pandey", mobileNumber: "+1(654) 559-5290")
    ]
    
    func getDriverList() -> [DriversList] {
        return driverDetailList.sorted()
    }
    func addDriversToList(newDriver : DriversList){
        driverDetailList.insert(newDriver, at: 0)
        driverDetailList.sort()
    }
    
    
    
    
    
}

var dataModel = DataModel()
