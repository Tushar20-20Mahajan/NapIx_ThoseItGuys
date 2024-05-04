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


struct DriversList : Equatable , Comparable , Codable{
    var name: String
    var mobileNumber: String
    var imageDriver : String
    static func ==(lhs: DriversList, rhs: DriversList) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    static func <(lhs: DriversList, rhs: DriversList) -> Bool {
        return lhs.name < rhs.name
        
    }
}

struct VehicleWiseList : Equatable,Comparable , Codable{
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


struct AlertBoardDataDisplayInformation : Codable {
    var imageAlert : String
    var route: String
    var vehicleNumber : String
    var driverName : String
}

struct AlertTimming {
    var iconImage : String
    var timeAlert : Date
}


struct ScheduleRoute{
    var vehicleNumber :String
    var driverName : String
    
    var fromLocation : String
    var toLocation : String
    
    var departureDetails : Date?
}

//struct VehicleNumberSelection: Equatable {
//    static func ==(lhs: VehicleNumberSelection, rhs: VehicleNumberSelection) -> Bool {
//        return lhs.vehicleNumber == rhs.vehicleNumber
//    }
//    
//    var vehicleNumber: String
//    private static let dataModel = DataModel()  // Instance of DataModel
//    
//    static var all: [VehicleWiseList] {
//        return dataModel.getVehicleList()  // Fetch vehicle list from DataModel
//    }
//}
//
//struct DriverNameSelection: Equatable {
//    static func ==(lhs: DriverNameSelection, rhs: DriverNameSelection) -> Bool {
//        return lhs.driverName == rhs.driverName && lhs.mobileNumber == rhs.mobileNumber
//    }
//    
//    var driverName: String
//    var mobileNumber: String
//    private static let dataModel = DataModel()  // Instance of DataModel
//    
//    static var all: [DriversList] {
//        return dataModel.getDriverList()  // Fetch driver list from DataModel
//    }
//}

class DataModel {
    private var vehicleList: [VehicleWiseList] = []
    private var driverDetailList: [DriversList] = []
    private var activeAlertOnAlertBoard: [AlertBoardDataDisplayInformation] = []
    private var drivingSafelyAlertOnAlertBoard: [AlertBoardDataDisplayInformation] = []
    private var scheduledAlertOnAlertBoard: [AlertBoardDataDisplayInformation] = []
    private var activeAlertTimmingsOnAlertBoard : [AlertTimming] = []
    
    init() {
        initializeVehicleList()
        initializeDriverDetailList()
        initializeActiveAlertOnAlertBoard()
        initializeDrivingSafelyAlertOnAlertBoard()
        initializeScheduledAlertOnAlertBoard()
        initializeActiveAlertTimmingsOnAlertBoard()
    }
    
    private func initializeVehicleList() {
            vehicleList = DataModel.loadFromFileVehicles() ?? [
                VehicleWiseList(vehicleNumber: "NYC 7777", imageNumberPlate: "numbersign"),
                VehicleWiseList(vehicleNumber: "GJZ 0196", imageNumberPlate: "numbersign"),
                VehicleWiseList(vehicleNumber: "NYC 8910", imageNumberPlate: "numbersign"),
                VehicleWiseList(vehicleNumber: "CAl 5910", imageNumberPlate: "numbersign"),
                VehicleWiseList(vehicleNumber: "WAS 3019", imageNumberPlate: "numbersign"),
                VehicleWiseList(vehicleNumber: "AZM 1718", imageNumberPlate: "numbersign"),
                VehicleWiseList(vehicleNumber: "SAM 6919", imageNumberPlate: "numbersign")
            ]
        }
        
        func getVehicleList() -> [VehicleWiseList] {
            return vehicleList.sorted()
        }
        
        func addVehicleToVehicleList(newVehicle: VehicleWiseList) {
            vehicleList.append(newVehicle)
            DataModel.saveToFileVehicles(vehicleList: vehicleList)
        }
        
        func removeVehicle(at index: Int) -> VehicleWiseList? {
            guard index >= 0 && index < vehicleList.count else {
                return nil
            }
            let removedVehicle = vehicleList.remove(at: index)
            DataModel.saveToFileVehicles(vehicleList: vehicleList)
            return removedVehicle
        }
        
        private static let DocumentDirectoryForVehicleList = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory
        private static let ArchiveURLForVehicleList = DocumentDirectoryForVehicleList.appendingPathComponent("vehicleList").appendingPathExtension("plist")
        
        static func saveToFileVehicles(vehicleList: [VehicleWiseList]) {
            let propertyListEncoder = PropertyListEncoder()
            if let codedDrivers = try? propertyListEncoder.encode(vehicleList) {
                try? codedDrivers.write(to: ArchiveURLForVehicleList, options: .noFileProtection)
            }
        }
        
        static func loadFromFileVehicles() -> [VehicleWiseList]? {
            guard let codedVehicles = try? Data(contentsOf: ArchiveURLForVehicleList) else {
                return nil
            }
            let propertyListDecoder = PropertyListDecoder()
            return try? propertyListDecoder.decode(Array<VehicleWiseList>.self, from: codedVehicles)
        }
    
//    static func saveToFileVehicles(vehicleList: [VehicleWiseList]) {
//        let propertyListEncoder = PropertyListEncoder()
//        if let codedVehicles = try? propertyListEncoder.encode(vehicleList) {
//            do {
//                try codedVehicles.write(to: ArchiveURLForVehicleList, options: .noFileProtection)
//                print("Vehicle list saved successfully!")
//            } catch {
//                print("Error saving vehicle list:", error)
//            }
//        } else {
//            print("Error encoding vehicle list.")
//        }
//    }
//
//    static func loadFromFileVehicles() -> [VehicleWiseList]? {
//        do {
//            let codedVehicles = try Data(contentsOf: ArchiveURLForVehicleList)
//            let propertyListDecoder = PropertyListDecoder()
//            let decodedVehicles = try propertyListDecoder.decode([VehicleWiseList].self, from: codedVehicles)
//            print("Vehicle list loaded successfully!")
//            return decodedVehicles
//        } catch {
//            print("Error loading vehicle list:", error)
//            return nil
//        }
//    }

    

    // Driver List

    
    private func initializeDriverDetailList() {
        driverDetailList =  DataModel.loadFromFileDrivers () ?? []
//            DriversList(name: "Tushar Mahajan", mobileNumber: "+1(654) 559-5290", imageDriver:"figure.seated.seatbelt"),
//            DriversList(name: "Utsav Sharma", mobileNumber: "+1(654) 559-5290", imageDriver: "figure.seated.seatbelt"),
//            DriversList(name: "Sunidhi Ratra", mobileNumber: "+1(654) 559-5290", imageDriver:"figure.seated.seatbelt"),
//            DriversList(name: "Ritik Pandey", mobileNumber: "+1(654) 559-5290", imageDriver: "figure.seated.seatbelt")
//        ]
    }
        
    func getDriverList() -> [DriversList] {
            return driverDetailList.sorted()
        }

        func addDriversToDriverList(newDriver: DriversList) {
            driverDetailList.append(newDriver)
            DataModel.saveToFileDrivers(driverDetailList: driverDetailList)
        }

        func removeDriver(at index: Int) -> DriversList? {
            guard index >= 0 && index < driverDetailList.count else {
                return nil
            }
            let removedDriver = driverDetailList.remove(at: index)
            DataModel.saveToFileDrivers(driverDetailList: driverDetailList)
            return removedDriver
        }

        // MARK: - File Operations

        private static let DocumentDirectoryForDriverList = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory
        private static let ArchiveURLForDriverList = DocumentDirectoryForDriverList.appendingPathComponent("driverDetailList").appendingPathExtension("plist")

        static func saveToFileDrivers(driverDetailList: [DriversList]) {
            let propertyListEncoder = PropertyListEncoder()
            if let codedDrivers = try? propertyListEncoder.encode(driverDetailList) {
                try? codedDrivers.write(to: ArchiveURLForDriverList, options: .noFileProtection)
            }
        }

        static func loadFromFileDrivers() -> [DriversList]? {
            guard let codedDrivers = try? Data(contentsOf: ArchiveURLForDriverList) else {
                return nil
            }
            let propertyListDecoder = PropertyListDecoder()
            return try? propertyListDecoder.decode(Array<DriversList>.self, from: codedDrivers)
        }

        static func removeFromFile() {
            do {
                // Attempt to remove the file containing the driver details
                try FileManager.default.removeItem(at: ArchiveURLForDriverList)
            } catch {
                // Handle error if file removal fails
                print("Error removing file:", error)
            }
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
        scheduledAlertOnAlertBoard = DataModel.loadFromFileScheduledRoute() ?? [
            AlertBoardDataDisplayInformation(imageAlert: "GreyAlert.jpeg", route: "London - Hamberg", vehicleNumber: "WAS 1718", driverName: "Vishal Kumar"),
            AlertBoardDataDisplayInformation(imageAlert: "GreyAlert.jpeg", route: "Paris - Geneva", vehicleNumber: "SAM 2222", driverName: "Prince Singh")
        ]
    }
    func getScheduledAlertOnAlertBoard() -> [AlertBoardDataDisplayInformation] {
        return scheduledAlertOnAlertBoard
    }
    
    func addScheduledAlertOnAlertBoard(newScheduledAlert: AlertBoardDataDisplayInformation) {
        scheduledAlertOnAlertBoard.insert(newScheduledAlert, at: 0)
        DataModel.saveToFileScheduledRoute(scheduledRoute: scheduledAlertOnAlertBoard)
    }
    func removeScheduledRoute(at index: Int) -> AlertBoardDataDisplayInformation? {
        guard index >= 0 && index < scheduledAlertOnAlertBoard.count else {
            return nil
        }
        let removedSchedule = scheduledAlertOnAlertBoard.remove(at: index)
        DataModel.saveToFileScheduledRoute(scheduledRoute: scheduledAlertOnAlertBoard)
        return removedSchedule
    }
    
    private static let DocumentDirectoryForScheduledRoute = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory
    private static let ArchiveURLForScheduledRoute = DocumentDirectoryForVehicleList.appendingPathComponent("scheduledAlertOnAlertBoard").appendingPathExtension("plist")
    
    static func saveToFileScheduledRoute(scheduledRoute: [AlertBoardDataDisplayInformation]) {
        let propertyListEncoder = PropertyListEncoder()
        if let codedScheduledRoute = try? propertyListEncoder.encode(scheduledRoute) {
            try? codedScheduledRoute.write(to: ArchiveURLForScheduledRoute, options: .noFileProtection)
        }
    }
    static func loadFromFileScheduledRoute() -> [AlertBoardDataDisplayInformation]? {
        guard let codedScheduledRoute = try? Data(contentsOf: ArchiveURLForScheduledRoute) else {
            return nil
        }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<AlertBoardDataDisplayInformation>.self, from: codedScheduledRoute)
    }

    
    // AlertTimmings
//    private func  initializeActiveAlertTimmingsOnAlertBoard() {
//        activeAlertTimmingsOnAlertBoard = [
//        
//            AlertTimming(iconImage: "eye.trianglebadge.exclamationmark.fill", timeAlert: "9:20 AM"),
//            AlertTimming(iconImage: "eye.trianglebadge.exclamationmark.fill", timeAlert: "9:18 AM"),
//            AlertTimming(iconImage: "eye.trianglebadge.exclamationmark.fill", timeAlert: "9:15 AM"),
//            AlertTimming(iconImage: "eye.trianglebadge.exclamationmark.fill", timeAlert: "9:12 AM")
//        ]
//        
//    }
    
    private func initializeActiveAlertTimmingsOnAlertBoard() {
        // Define the time strings
        let timeStrings = ["9:20 AM", "9:18 AM", "9:15 AM", "9:12 AM"]
        
        // Create a DateFormatter to parse the time strings
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        // Initialize the alert timings array with Date objects
        activeAlertTimmingsOnAlertBoard = timeStrings.compactMap { timeString in
            guard let timeDate = dateFormatter.date(from: timeString) else {
                fatalError("Failed to parse time string: \(timeString)")
            }
            return AlertTimming(iconImage: "eye.trianglebadge.exclamationmark.fill", timeAlert: timeDate)
        }
    }

    
    func getAlertTimmingsOnAlertBoard() -> [AlertTimming] {
        return activeAlertTimmingsOnAlertBoard
    }
    func addNewAlertonAlertBoard(newAlert : AlertTimming){
        activeAlertTimmingsOnAlertBoard.insert(newAlert, at: 0)
    }
}


var dataModel = DataModel()
