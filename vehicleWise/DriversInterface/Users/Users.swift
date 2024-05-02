import Foundation

// Enum to represent user types
enum UserType {
    case logisticsTeam
    case driver
}

// Struct to represent a user
struct User {
    let userId: UUID
    let password: String // It's recommended to store passwords securely, this could be a hashed value
    let userType: UserType
}

// Struct to represent sign-up data
struct SignUpData {
    let name: String
    let email: String
    let phone: String?
    let licenseNumber: String?
    let vehicleType: String?
}

// Struct to represent profile data for logistics team
struct LogisticsTeamProfile {
    let name: String
    let email: String
    let phone: String
}

// Struct to represent profile data for drivers
struct DriverProfile {
    let name: String
    let licenseNumber: String
    let vehicleType: String
}

// Function for sign-up
func signUp(userId: UUID, password: String, userType: UserType, signUpData: SignUpData) -> (User, Any) {
    let newUser = User(userId: userId, password: password, userType: userType)
    
    switch userType {
    case .logisticsTeam:
        let logisticsTeamProfile = LogisticsTeamProfile(name: signUpData.name, email: signUpData.email, phone: signUpData.phone ?? "")
        return (newUser, logisticsTeamProfile)
    case .driver:
        guard let licenseNumber = signUpData.licenseNumber, let vehicleType = signUpData.vehicleType else {
            return (newUser, "Missing required fields for driver sign-up")
        }
        let driverProfile = DriverProfile(name: signUpData.name, licenseNumber: licenseNumber, vehicleType: vehicleType)
        return (newUser, driverProfile)
    }
}

// Function for accessing profile data
func accessProfile<T>(user: User, profileData: T) {
    switch user.userType {
    case .logisticsTeam:
        if let logisticsTeamProfile = profileData as? LogisticsTeamProfile {
            print("Logistics Team Profile:")
            print("Name: \(logisticsTeamProfile.name)")
            print("Email: \(logisticsTeamProfile.email)")
            print("Phone: \(logisticsTeamProfile.phone)")
            print("---------------------")
        }
    case .driver:
        if let driverProfile = profileData as? DriverProfile {
            print("Driver Profile:")
            print("Name: \(driverProfile.name)")
            print("License Number: \(driverProfile.licenseNumber)")
            print("Vehicle Type: \(driverProfile.vehicleType)")
            print("---------------------")
        }
    }
}

// Dummy data for logistics team sign-up
let logisticsTeamSignUpData = SignUpData(name: "Logistics Team Member", email: "logistics@example.com", phone: "1234567890", licenseNumber: nil, vehicleType: nil)

// Dummy data for driver sign-up
let driverSignUpData = SignUpData(name: "Driver", email: "driver@example.com", phone: nil, licenseNumber: "123456", vehicleType: "Truck")

// Sign-up logistics team member
let logisticsTeamUser = User(userId: UUID(), password: "hashed_password", userType: .logisticsTeam)
let (logisticsTeamProfileUser, logisticsTeamProfileData) = signUp(userId: logisticsTeamUser.userId, password: logisticsTeamUser.password, userType: .logisticsTeam, signUpData: logisticsTeamSignUpData)

// Sign-up driver
let driverUser = User(userId: UUID(), password: "hashed_password", userType: .driver)
let (driverProfileUser, driverProfileData) = signUp(userId: driverUser.userId, password: driverUser.password, userType: .driver, signUpData: driverSignUpData)

// Access profiles
func main() {
    // Dummy data for logistics team sign-up
    let logisticsTeamSignUpData = SignUpData(name: "Logistics Team Member", email: "logistics@example.com", phone: "1234567890", licenseNumber: nil, vehicleType: nil)
    
    // Dummy data for driver sign-up
    let driverSignUpData = SignUpData(name: "Driver", email: "driver@example.com", phone: nil, licenseNumber: "123456", vehicleType: "Truck")
    
    // Sign-up logistics team member
    let logisticsTeamUser = User(userId: UUID(), password: "hashed_password", userType: .logisticsTeam)
    let (logisticsTeamProfileUser, logisticsTeamProfileData) = signUp(userId: logisticsTeamUser.userId, password: logisticsTeamUser.password, userType: .logisticsTeam, signUpData: logisticsTeamSignUpData)
    
    // Sign-up driver
    let driverUser = User(userId: UUID(), password: "hashed_password", userType: .driver)
    let (driverProfileUser, driverProfileData) = signUp(userId: driverUser.userId, password: driverUser.password, userType: .driver, signUpData: driverSignUpData)
    
    // Access profiles
    accessProfile(user: logisticsTeamProfileUser, profileData: logisticsTeamProfileData)
    accessProfile(user: driverProfileUser, profileData: driverProfileData)
}


