
//  DataModel.swift


import Foundation
import UIKit

// Struct representing details of a driver
struct DriversList: Equatable, Comparable, Codable {
    var name: String
    var mobileNumber: String
    var imageDriver: String
    
    // Implementing Equatable protocol for comparing driver details
    static func ==(lhs: DriversList, rhs: DriversList) -> Bool {
        return lhs.name == rhs.name && lhs.mobileNumber == rhs.mobileNumber
    }
    
    // Implementing Comparable protocol for sorting driver details by name
    static func <(lhs: DriversList, rhs: DriversList) -> Bool {
        return lhs.name < rhs.name
    }
}

// Struct representing details of a vehicle
struct VehicleWiseList: Equatable, Comparable, Codable {
    var vehicleNumber: String
    var imageNumberPlate: String
    
    // Implementing Equatable protocol for comparing vehicle details
    static func ==(lhs: VehicleWiseList, rhs: VehicleWiseList) -> Bool {
        return lhs.vehicleNumber == rhs.vehicleNumber
    }
    
    // Implementing Comparable protocol for sorting vehicle details by number
    static func <(lhs: VehicleWiseList, rhs: VehicleWiseList) -> Bool {
        return lhs.vehicleNumber < rhs.vehicleNumber
    }
}

// Struct representing information displayed on the alert board
struct AlertBoardDataDisplayInformation: Codable {
    var imageAlert: String
    var route: String
    var vehicleNumber: String
    var driverName: DriversList
    var departureDetails: String
    var alertTimmings : [AlertTimming]
}

// Struct representing a scheduled truck
struct ScheduledTruck: Codable {
    var passKeyId: String
    var truckInfo: AlertBoardDataDisplayInformation
}

// Struct representing alert timings
struct AlertTimming : Codable {
    var iconImage: String
    var timeAlert: String
    var alertMessage : String
}





// Class managing data operations
class DataModel {
    // Arrays to store lists of vehicles, drivers, and alert board information
    private var vehicleList: [VehicleWiseList] = []
    private var driverDetailList: [DriversList] = []
    private var activeAlertOnAlertBoard: [String:AlertBoardDataDisplayInformation] = [:]
    private var drivingSafelyAlertOnAlertBoard: [String:AlertBoardDataDisplayInformation] = [:]
    private var scheduledAlertOnAlertBoard: [String : AlertBoardDataDisplayInformation] = [:]
    private var activeAlertTimmingsOnAlertBoard : [AlertTimming] = []
    private var vehicleRouteIdS : Set<String> = []
   
    
    // Initialize data when the class is instantiated
    init() {
        initializeVehicleList()
        initializeDriverDetailList()
        initializeActiveAlertOnAlertBoard()
        initializeDrivingSafelyAlertOnAlertBoard()
        initializeScheduledAlertOnAlertBoard()
        initializeActiveAlertTimmingsOnAlertBoard()
    }
    func getVehicleRoutePassIDS() -> [String] {
        return Array(vehicleRouteIdS)
    }
    
    func addNewPassIDRoute(newPasID: String) {
        vehicleRouteIdS.insert(newPasID)
    }


    
    // Vehicle-related operations
       
       // Initialize vehicle list
    private func initializeVehicleList() {
        // Load vehicles from file if available, otherwise use default values
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
    // Get the list of vehicles sorted by number
        func getVehicleList() -> [VehicleWiseList] {
            return vehicleList.sorted()
        }
    // Add a new vehicle to the list
        func addVehicleToVehicleList(newVehicle: VehicleWiseList) {
            vehicleList.append(newVehicle)
            DataModel.saveToFileVehicles(vehicleList: vehicleList)
        }
    // Remove a vehicle from the list
        func removeVehicle(at index: Int) -> VehicleWiseList? {
            // Ensure the index is valid before removing the vehicle
            guard index >= 0 && index < vehicleList.count else {
                return nil
            }
            let removedVehicle = vehicleList.remove(at: index)
            DataModel.saveToFileVehicles(vehicleList: vehicleList)
            return removedVehicle
        }
    
    // File Operations for Vehicles
        
    // Define a static constant for the directory to store the vehicle list.
    // If the document directory is not available, use the temporary directory as a fallback.
    private static let DocumentDirectoryForVehicleList = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory

    // Define a static constant for the URL where the vehicle list plist will be stored.
    // This appends "vehicleList.plist" to the path of the directory defined above.
    private static let ArchiveURLForVehicleList = DocumentDirectoryForVehicleList.appendingPathComponent("vehicleList").appendingPathExtension("plist")

    // Static method to save an array of 'VehicleWiseList' objects to a plist file.
    static func saveToFileVehicles(vehicleList: [VehicleWiseList]) {
        // Create a new PropertyListEncoder to encode the vehicle list array.
        let propertyListEncoder = PropertyListEncoder()
        // Attempt to encode the array of 'VehicleWiseList' objects.
        if let codedDrivers = try? propertyListEncoder.encode(vehicleList) {
            // If encoding is successful, attempt to write the encoded data to the specified plist file.
            // Do not use file protection options.
            try? codedDrivers.write(to: ArchiveURLForVehicleList, options: .noFileProtection)
        }
    }

    // Static method to load an array of 'VehicleWiseList' objects from a plist file.
    static func loadFromFileVehicles() -> [VehicleWiseList]? {
        // Attempt to read data from the plist file at the specified URL.
        guard let codedVehicles = try? Data(contentsOf: ArchiveURLForVehicleList) else {
            // If reading fails, return nil indicating that the vehicle list could not be loaded.
            return nil
        }
        // Create a new PropertyListDecoder to decode the data into an array of 'VehicleWiseList' objects.
        let propertyListDecoder = PropertyListDecoder()
        // Attempt to decode the data into an array of 'VehicleWiseList' objects and return it.
        return try? propertyListDecoder.decode(Array<VehicleWiseList>.self, from: codedVehicles)
    }
    static func removeFromFileVehicles() {
        do {
            // Attempt to remove the file containing the driver details
            try FileManager.default.removeItem(at: ArchiveURLForVehicleList)
        } catch {
            // Handle error if file removal fails
            print("Error removing file:", error)
        }
    }


    

    // Driver-related operations
       
       // Initialize driver list
    private func initializeDriverDetailList() {
        // Load drivers from file if available, otherwise use default values
        driverDetailList =  DataModel.loadFromFileDrivers () ?? [
            DriversList(name: "Tushar Mahajan", mobileNumber: "+1(654) 559-5290", imageDriver:"figure.seated.seatbelt"),
            DriversList(name: "Utsav Sharma", mobileNumber: "+1(654) 559-5290", imageDriver: "figure.seated.seatbelt"),
            DriversList(name: "Sunidhi Ratra", mobileNumber: "+1(654) 559-5290", imageDriver:"figure.seated.seatbelt"),
            DriversList(name: "Ritik Pandey", mobileNumber: "+1(654) 559-5290", imageDriver: "figure.seated.seatbelt")
        ]
    }
        
    // Get the list of drivers sorted by name
    func getDriverList() -> [DriversList] {
            return driverDetailList.sorted()
        }

    // Add a new driver to the list
        func addDriversToDriverList(newDriver: DriversList) {
            driverDetailList.append(newDriver)
            DataModel.saveToFileDrivers(driverDetailList: driverDetailList)
        }

    // Remove a driver from the lis
        func removeDriver(at index: Int) -> DriversList? {
            // Ensure the index is valid before removing the driver
            guard index >= 0 && index < driverDetailList.count else {
                return nil
            }
            let removedDriver = driverDetailList.remove(at: index)
            DataModel.saveToFileDrivers(driverDetailList: driverDetailList)
            return removedDriver
        }

    // MARK: - File Operations

    // File URLs for saving/loading driver list
    private static let DocumentDirectoryForDriverList = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory
    private static let ArchiveURLForDriverList = DocumentDirectoryForDriverList.appendingPathComponent("driverDetailList").appendingPathExtension("plist")

    // Save driver list to file
    static func saveToFileDrivers(driverDetailList: [DriversList]) {
        let propertyListEncoder = PropertyListEncoder()
        if let codedDrivers = try? propertyListEncoder.encode(driverDetailList) {
            try? codedDrivers.write(to: ArchiveURLForDriverList, options: .noFileProtection)
        }
    }

    // Load driver list from file
    static func loadFromFileDrivers() -> [DriversList]? {
        guard let codedDrivers = try? Data(contentsOf: ArchiveURLForDriverList) else {
            return nil
        }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<DriversList>.self, from: codedDrivers)
    }

    // Remove driver list file
    static func removeFromFileDrivers() {
        do {
            // Attempt to remove the file containing the driver details
            try FileManager.default.removeItem(at: ArchiveURLForDriverList)
        } catch {
            // Handle error if file removal fails
            print("Error removing file:", error)
        }
    }

    
    // Function to generate a random pass key
    func generatePassKey() -> String {
        // Define the source string containing characters for the pass key
        let sourceString = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        // Initialize an empty array to store characters from the source string
        var sequenceOfCharacters: [Character] = []
        
        // Populate the sequenceOfCharacters array with characters from the source string
        for character in sourceString {
            sequenceOfCharacters.append(character)
        }
        
        // Define the length of the pass key
        let passwordLength = 4
        
        // Initialize an empty array to store characters for the pass key
        var myPassword: [Character] = []
        
        // Generate random characters for the pass key
        for _ in 0..<passwordLength {
            // Generate a random index to pick a character from the sequenceOfCharacters array
            let randomPositionPicker = Int.random(in: 0..<sequenceOfCharacters.count)
            
            // Append the randomly picked character to the pass key
            myPassword.append(sequenceOfCharacters[randomPositionPicker])
        }
        
        // Convert the array of characters into a string to form the pass key
        let password = String(myPassword)
        
        // Return the generated pass key
        return password
    }

    
    // Alert Board Operations

    // Initialize active alerts on the alert board with sample data
    private func initializeActiveAlertOnAlertBoard() {
        activeAlertOnAlertBoard = [
            "d4e5": AlertBoardDataDisplayInformation(imageAlert: "RedAlert.jpeg", route: "New York - Toronto", vehicleNumber: "AZM 1718", driverName: DriversList(name: "Arman Malik",mobileNumber: "+1(654) 559-5290", imageDriver: "figure.seated.seatbelt"), departureDetails: "dd/MM/yyyy HH:mm", alertTimmings: []),
            "i9h8": AlertBoardDataDisplayInformation(imageAlert: "RedAlert.jpeg", route: "Los Angeles - Frenos", vehicleNumber: "NYC 1988", driverName: DriversList(name: "Crolis Nep", mobileNumber: "+1(654) 559-5290", imageDriver: "figure.seated.seatbelt"), departureDetails: "dd/MM/yyyy HH:mm", alertTimmings: [])
        ]
    }

    // Retrieve active alerts on the alert board
    func getActiveAlertOnAlertBoard() -> [String: AlertBoardDataDisplayInformation] {
        return activeAlertOnAlertBoard
    }

    // Initialize driving safely alerts on the alert board with sample data
    private func initializeDrivingSafelyAlertOnAlertBoard() {
        drivingSafelyAlertOnAlertBoard = [
            "LMNO": AlertBoardDataDisplayInformation(imageAlert: "BlueAlert.jpeg", route: "London - Hamberg", vehicleNumber: "WAS 1718", driverName: DriversList(name: "James", mobileNumber: "+1(654) 559-5290", imageDriver: "figure.seated.seatbelt"), departureDetails: "dd/MM/yyyy HH:mm", alertTimmings: []),
            "1A2B": AlertBoardDataDisplayInformation(imageAlert: "BlueAlert.jpeg", route: "Paris - Geneva", vehicleNumber: "SAM 2222", driverName: DriversList(name: "RamLal", mobileNumber: "+1(654) 559-5290", imageDriver: "figure.seated.seatbelt"), departureDetails: "dd/MM/yyyy HH:mm", alertTimmings: [])
        ]
    }

    // Retrieve driving safely alerts on the alert board
    func getDrivingSafelyAlertOnAlertBoard() -> [String: AlertBoardDataDisplayInformation] {
        return drivingSafelyAlertOnAlertBoard
    }

    // Initialize scheduled alerts on the alert board with sample data loaded from file or default values
    private func initializeScheduledAlertOnAlertBoard() {
        scheduledAlertOnAlertBoard = DataModel.loadFromFileScheduledRoute() ?? [
            "1234": AlertBoardDataDisplayInformation(imageAlert: "GreyAlert.jpeg", route: "London - Hamberg", vehicleNumber: "WAS 1718", driverName: DriversList(name: "Amit", mobileNumber: "+1(654) 559-5290", imageDriver: "figure.seated.seatbelt"), departureDetails: "dd/MM/yyyy HH:mm", alertTimmings: []),
            "5678": AlertBoardDataDisplayInformation(imageAlert: "GreyAlert.jpeg", route: "Paris - Geneva", vehicleNumber: "SAM 2222", driverName: DriversList(name: "Prab Singh",  mobileNumber: "+1(654) 559-5290", imageDriver: "figure.seated.seatbelt"), departureDetails: "dd/MM/yyyy HH:mm", alertTimmings: [])
        ]
    }

    // Retrieve scheduled alerts on the alert board
    func getScheduledAlertOnAlertBoard() -> [String: AlertBoardDataDisplayInformation] {
        return scheduledAlertOnAlertBoard
    }

    // Add a new scheduled alert to the alert board and save it to file
    func addScheduledAlertOnAlertBoard(newScheduledAlert: (String, AlertBoardDataDisplayInformation)) {
        scheduledAlertOnAlertBoard[newScheduledAlert.0] = newScheduledAlert.1
        DataModel.saveToFileScheduledRoute(scheduledRoute: scheduledAlertOnAlertBoard)
    }

    // Remove a scheduled route from the alert board and update file storage
    func removeScheduledRoute(forKey key: String) -> AlertBoardDataDisplayInformation? {
        guard let removedSchedule = scheduledAlertOnAlertBoard.removeValue(forKey: key) else {
            return nil
        }
        DataModel.saveToFileScheduledRoute(scheduledRoute: scheduledAlertOnAlertBoard)
        return removedSchedule
    }

    // File operations for scheduled route data
    private static let DocumentDirectoryForScheduledRoute = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory
    private static let ArchiveURLForScheduledRoute = DocumentDirectoryForScheduledRoute.appendingPathComponent("scheduledAlertOnAlertBoard").appendingPathExtension("plist")

    // Save scheduled route data to file
    static func saveToFileScheduledRoute(scheduledRoute: [String: AlertBoardDataDisplayInformation]) {
        let propertyListEncoder = PropertyListEncoder()
        if let codedScheduledRoute = try? propertyListEncoder.encode(scheduledRoute) {
            try? codedScheduledRoute.write(to: ArchiveURLForScheduledRoute, options: .noFileProtection)
        }
    }

    // Load scheduled route data from file
    static func loadFromFileScheduledRoute() -> [String: AlertBoardDataDisplayInformation]? {
        guard let codedScheduledRoute = try? Data(contentsOf: ArchiveURLForScheduledRoute) else {
            return nil
        }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Dictionary<String, AlertBoardDataDisplayInformation>.self, from: codedScheduledRoute)
    }

    // Alert Timings Operations

    // Initialize active alert timings on the alert board with sample data
    private func initializeActiveAlertTimmingsOnAlertBoard() {
       
        
        // Initialize the alert timings array with Date objects
        activeAlertTimmingsOnAlertBoard = []
        
        }
    

    // Retrieve active alert timings on the alert board
        func getAlertTimmingsOnAlertBoard() -> [AlertTimming] {
            return activeAlertTimmingsOnAlertBoard
        }

        // Add a new alert timing to the alert board
        func addNewAlertOnAlertBoard(newAlert: AlertTimming) {
            activeAlertTimmingsOnAlertBoard.insert(newAlert, at: 0)
        }

}

// Instantiate DataModel
var dataModel = DataModel()
