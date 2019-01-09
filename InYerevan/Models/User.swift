import Foundation

class User {
    
    public static var administration: [String] = ["harmik@gmail.com",
                                                  "davxush@gmail.com",
                                                  "vahtad@gmail.com",
                                                  "gevdar@gmail.com"]
    
    public static var email: String {
        let email = UserDefaults.standard.object(forKey: "userEmail") as! String
        return email
    }
    
    public static var isAdministration: Bool {
        let bool = UserDefaults.standard.object(forKey: "isAdministration") as! Bool
        return bool
    }
}
