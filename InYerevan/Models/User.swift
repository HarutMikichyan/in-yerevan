import Foundation

class User {
    
    public static var administration: [String] = ["harmik@gmail.com",
                                                  "davxush@gmail.com",
                                                  "vahtad@gmail.com",
                                                  "gevdar@gmail.com"]
    
    public static var email: String {
        get {
            let email = UserDefaults.standard.object(forKey: "userEmail") as? String ?? ""
            return email
        }
        
        set(value) {
            UserDefaults.standard.set(value, forKey: "userEmail")
        }
    }
    
    public static var isAdministration: Bool {
        get {
            let bool = UserDefaults.standard.object(forKey: "isAdministration") as! Bool
            return bool
        }
        
        set(value) {
            UserDefaults.standard.set(value, forKey: "isAdministration")
        }
    }
}
