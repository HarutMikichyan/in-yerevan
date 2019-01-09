import Foundation

class User {
    
    public static var email: String {
        let email = UserDefaults.standard.object(forKey: "userEmail") as! String
        return email
    }
    
    public var isAdministration: Bool {
        let bool = UserDefaults.standard.object(forKey: "isAdministration") as! Bool
        return bool
    }
}
