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
    var imageDriver : UIImage
    static func ==(lhs: DriversList, rhs: DriversList) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    static func <(lhs: DriversList, rhs: DriversList) -> Bool {
        return lhs.name < rhs.name
        
    }
}

struct VehicleWiseList : Equatable,Comparable{
    var vehicleNumber : String
    var imageNumberPlate : String
    // Implementing Equatable protocol
        static func ==(lhs: VehicleWiseList, rhs: VehicleWiseList) -> Bool {
            return lhs.vehicleNumber == rhs.vehicleNumber
        }
//        
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

class DataModel {
    private var vehicleList: [VehicleWiseList] = []
    private var driverDetailList: [DriversList] = []
    private var activeAlertOnAlertBoard: [AlertBoardDataDisplayInformation] = []
    private var drivingSafelyAlertOnAlertBoard: [AlertBoardDataDisplayInformation] = []
    private var scheduledAlertOnAlertBoard: [AlertBoardDataDisplayInformation] = []
    
    init() {
        initializeVehicleList()
        initializeDriverDetailList()
        initializeActiveAlertOnAlertBoard()
        initializeDrivingSafelyAlertOnAlertBoard()
        initializeScheduledAlertOnAlertBoard()
    }
    
    private func initializeVehicleList() {
        vehicleList = [
            VehicleWiseList(vehicleNumber: "NYC 7777", imageNumberPlate: "numbersign"),
            VehicleWiseList(vehicleNumber: "GJZ 0196", imageNumberPlate: "numbersign"),
            VehicleWiseList(vehicleNumber: "NYC 8910", imageNumberPlate:"numbersign"),
            VehicleWiseList(vehicleNumber: "CAl 5910", imageNumberPlate:"numbersign"),
            VehicleWiseList(vehicleNumber: "WAS 3019", imageNumberPlate:"numbersign"),
            VehicleWiseList(vehicleNumber: "AZM 1718", imageNumberPlate:"numbersign"),
            VehicleWiseList(vehicleNumber: "SAM 6919", imageNumberPlate: "numbersign")
        ]
    }

    func getVehicleList() -> [VehicleWiseList] {
        return vehicleList.sorted()
    }
    
    func addVehicleToVehicleList(newVehicle: VehicleWiseList) {
        vehicleList.insert(newVehicle, at: 0)
    }
    
//    private func makeModifiedImage(for systemName: String) -> UIImage {
//        let originalImage = UIImage(systemName: systemName)!
//        let tintedImage = originalImage.withTintColor(.black)
//        let resizedImage = tintedImage.resizedTo(width: 27, height: 22)
//        let lightGrayBackground = resizedImage.addLightGrayBackground()
//        return lightGrayBackground
//    }
    
    private func makeModifiedImageDriver(for systemName: String) -> UIImage {
        let originalImage = UIImage(systemName: systemName)!
        let tintedImage = originalImage.withTintColor(.black)
        let resizedImage = tintedImage.resizedTo(width: 32, height: 27)
        let lightGrayBackground = resizedImage.addLightGrayBackground()
        return lightGrayBackground
    }
    
    private func initializeDriverDetailList() {
        driverDetailList = [
            DriversList(name: "Tushar Mahajan", mobileNumber: "+1(654) 559-5290", imageDriver: makeModifiedImageDriver(for: "figure.seated.seatbelt")),
            DriversList(name: "Utsav Sharma", mobileNumber: "+1(654) 559-5290", imageDriver: makeModifiedImageDriver(for: "figure.seated.seatbelt")),
            DriversList(name: "Sunidhi Ratra", mobileNumber: "+1(654) 559-5290", imageDriver: makeModifiedImageDriver(for: "figure.seated.seatbelt")),
            DriversList(name: "Ritik Pandey", mobileNumber: "+1(654) 559-5290", imageDriver: makeModifiedImageDriver(for: "figure.seated.seatbelt"))
        ]
    }
        
    func getDriverList() -> [DriversList] {
        return driverDetailList.sorted()
    }
        
    func addDriversToDriverList(newDriver: DriversList) {
        driverDetailList.insert(newDriver, at: 0)
    }
    
    // Alert Board
    private func initializeActiveAlertOnAlertBoard() {
        activeAlertOnAlertBoard = [
            AlertBoardDataDisplayInformation(imageAlert: "RedAlert.jpeg", route: "New York - Toronto", vehicleNumber: "AZM 1718", driverName: "Ritik Pandey"),
            AlertBoardDataDisplayInformation(imageAlert: "RedAlert.jpeg", route: "Los Angeles - Frenos", vehicleNumber: "NYC 1988", driverName: "Arman Kumar")
        ]
    }
    func getActiveAlertOnAlertBoard() -> [AlertBoardDataDisplayInformation] {
        return activeAlertOnAlertBoard
    }
    
    private func  initializeDrivingSafelyAlertOnAlertBoard() {
        drivingSafelyAlertOnAlertBoard = [
            AlertBoardDataDisplayInformation(imageAlert: "BlueAlert.jpeg", route: "London - Hamberg", vehicleNumber: "WAS 1718", driverName: "Vishal Kumar"),
            AlertBoardDataDisplayInformation(imageAlert: "BlueAlert.jpeg", route: "Paris - Geneva", vehicleNumber: "SAM 2222", driverName: "Prince Singh")
        ]
    }
    func getDrivingSafelyAlertOnAlertBoard() -> [AlertBoardDataDisplayInformation] {
        return drivingSafelyAlertOnAlertBoard
    }
    
    private func  initializeScheduledAlertOnAlertBoard() {
        scheduledAlertOnAlertBoard = [
            AlertBoardDataDisplayInformation(imageAlert: "GreyAlert.jpeg", route: "London - Hamberg", vehicleNumber: "WAS 1718", driverName: "Vishal Kumar"),
            AlertBoardDataDisplayInformation(imageAlert: "GreyAlert.jpeg", route: "Paris - Geneva", vehicleNumber: "SAM 2222", driverName: "Prince Singh")
        ]
    }
    func getScheduledAlertOnAlertBoard() -> [AlertBoardDataDisplayInformation] {
        return scheduledAlertOnAlertBoard
    }
    
    func addScheduledAlertOnAlertBoard(newScheduledAlert: AlertBoardDataDisplayInformation) {
        scheduledAlertOnAlertBoard.insert(newScheduledAlert, at: 0)
    }
}

extension UIImage {
    func addLightGrayBackground() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.lightGray.cgColor)
        context.fill(CGRect(origin: CGPoint.zero, size: self.size))
        self.draw(at: CGPoint.zero, blendMode: .normal, alpha: 1.0)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizedTo(width: CGFloat, height: CGFloat) -> UIImage {
        let newSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}


var dataModel = DataModel()
