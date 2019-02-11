//
//  HomeViewController.swift
//  In Yerevan
//
//  Created by Gev Darbinyan on 17/12/2018.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleMobileAds

class HomeViewController: UIViewController {

    // MARK:- INTERFACE BUILDER OUTLETS

    @IBOutlet weak var courseUSD: UILabel!
    @IBOutlet weak var courseRUR: UILabel!
    @IBOutlet weak var courseEUR: UILabel!
    @IBOutlet weak var weatherYerevan: UILabel!
    @IBOutlet weak var imageInHome: UIImageView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherTemperature: UILabel!
    @IBOutlet weak var onlineSupportButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!

    // MARK:- OTHER PROPERTIES
    
    private var imageHotels = [UIImage]()
    private var imageEvents = [UIImage]()
    private var imageRestaurants = [UIImage]()
    private var name = User.email
    private var channels = [Channel]()
    private var hotels = [HotelsType]()
    private let db = Firestore.firestore()
    private var channelListener: ListenerRegistration?
    private var channelReference: CollectionReference {
        return db.collection("channels")
    }
    
    private var yerevanImages: [UIImage] = [] {
        willSet(newImage) {
            if yerevanImages.count < 1 {
                imageInHome.image = newImage[0]
            }
        }
    }
    private var currency: CurrencyType! {
        didSet {
            courseEUR.text = " EUR| \(currency.currencyEUR) AMD"
            courseUSD.text = " USD| \(currency.currencyUSD) AMD"
            courseRUR.text = " RUR|   \(currency.currencyRUR) AMD"
        }
    }
    
    // MARK:- ALERT PROPERTIES
    
    var errorTextField: UITextField!
    var newPassrodTextField: UITextField!
    var oldPasswordTextField: UITextField!
    var repeatNewPasswordTextField: UITextField!
    var alertChangeButton: UIAlertAction!

    // MARK:- VIEW LIFE CYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.appDelegate.refCurrency.observe(.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                for curr in snapshot.children.allObjects as! [DataSnapshot] {
                    let currencyObject = curr.value  as! [String: AnyObject]
                    let id = currencyObject["id"]
                    let eur = currencyObject["currencyEUR"]
                    let usa = currencyObject["currencyUSD"]
                    let rur = currencyObject["currencyRUR"]
                    
                    let currency = CurrencyType(id: id as! String, currencyEUR: eur as! Double, currencyUSD: usa as! Double, currencyRUR: rur as! Double)
                    self.currency = currency
                }
            }
        }
        
        DataProvider.object.getWeather { (weather, bool) in
            if bool {
                DispatchQueue.main.async {
                    let weekday = Calendar.current.component(.weekday, from: Date())
                    if weather!.temperatureC! > 0 {
                        self.weatherTemperature.text = "+\(Int(weather!.temperatureC!))"
                    } else {
                        self.weatherTemperature.text = "\(Int(weather!.temperatureC!))"
                    }
                    self.weatherIcon.image = weather!.icon
                    self.weatherYerevan.text = "C \(Date.weeakdayByString(numberDay: weekday))"
                }
            } else {
                print("Error Object is Nil")
            }
        }
        
        DataProvider.object.getYerevanImagesInfo { (image, bool) in
            if bool {
                DispatchQueue.main.async {
                    self.yerevanImages.append(image!)
                }
            }
        }
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .outgoingLavender
        
        onlineSupportButton.layer.cornerRadius = 12
        onlineSupportButton.layer.masksToBounds = true
        
        changePasswordButton.layer.cornerRadius = 12
        changePasswordButton.layer.masksToBounds = true
        
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        
        channelListener = channelReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }

        if User.email == "guest" {
            onlineSupportButton.isEnabled = false
            onlineSupportButton.setTitleColor(UIColor.white, for: .normal)
            onlineSupportButton.backgroundColor = UIColor.white
        }
    }
    
    // MARK:- ACTIONS
    
    @IBAction func signOutAction(_ sender: Any) {
        let blurredSubview = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        let alert = UIAlertController(title: "Do you really want to leave?", message: "", preferredStyle: .alert)
        
        alert.view.tintColor = .outgoingLavender
        alert.view.backgroundColor = .black

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(UIAlertAction) in
            User.email = ""
            User.isAdministration = false
            
            let myStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = myStoryboard.instantiateViewController(withIdentifier: "registrationvc")
            
            UIApplication.shared.keyWindow?.rootViewController = vc
            blurredSubview.removeFromSuperview()
        }))
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: {(_) in
            blurredSubview.removeFromSuperview()
        }))
        
        UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        let blurredSubview = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        if alertChangeButton != nil {
            alertChangeButton.isEnabled = false
        }
        
        let alert = UIAlertController(title: "Reset Password Error", message: "Text field is empty", preferredStyle: .alert)
        alert.view.tintColor = .outgoingLavender
        alert.view.backgroundColor = .black
        alert.addTextField { (UITextField) in
            self.oldPasswordTextField = UITextField
            self.oldPasswordTextField.delegate = self
            UITextField.backgroundColor = UIColor.clear
            UITextField.placeholder = "Old Password"
        }
        alert.addTextField { (UITextField) in
            self.newPassrodTextField = UITextField
            self.newPassrodTextField.delegate = self
            UITextField.isSecureTextEntry = true

            UITextField.backgroundColor = UIColor.clear
            UITextField.placeholder = "New Password"
        }
        alert.addTextField { (UITextField) in
            self.repeatNewPasswordTextField = UITextField
            self.repeatNewPasswordTextField.delegate = self
            UITextField.isSecureTextEntry = true

            UITextField.backgroundColor = UIColor.clear
            UITextField.placeholder = "Repeat New Password"
        }
        alertChangeButton = UIAlertAction(title: "Change", style: .default, handler: {(UIAlertAction) in
            
            // TO DO:
    
        })
        alert.addAction(alertChangeButton)
        alertChangeButton.isEnabled = false
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: {(_) in
            blurredSubview.removeFromSuperview()
        }))
        
        alert.addTextField { (UITextField) in
            UITextField.backgroundColor = UIColor.clear
            UITextField.isHidden = true
            UITextField.isEnabled = false
            UITextField.textColor = UIColor.red
            self.errorTextField = UITextField
        }
        
        UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)        
    }

    @IBAction func onlineSupportAction() {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        if User.isAdministration {
            let vc = sb.instantiateViewController(withIdentifier: "userlist") as! UserListViewController
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = sb.instantiateViewController(withIdentifier: "chatvc") as! ChatViewController
            if channels.contains(Channel(name: name)) {
                let index = channels.index(of: Channel(name: name))
                vc.channel = channels[index!]
                navigationController?.pushViewController(vc, animated: true)
            } else {
                channelReference.addDocument(data: Channel(name: name).representation) { error in
                    if let error = error {
                        print("Error saving channel: \(error.localizedDescription)")
                    }
                }
            }
            vc.title = "Customer Support"
        }
    }
    
    // MARK:- PRIVATE METHODS
    
    private func addChannelToTable(_ channel: Channel) {
        guard !channels.contains(channel) else { return }
        channels.append(channel)
        channels.sort()
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let channel = Channel(document: change.document) else { return }
        switch change.type {
        case .added:
            addChannelToTable(channel)
        default:
            break
        }
    }
    
    deinit {
        channelListener?.remove()
    }
}

extension HomeViewController: UITextFieldDelegate  {
    // MARK:- UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == oldPasswordTextField {
            if oldPasswordTextField.text!.isEmpty {
                errorTextField.isHidden = false
                errorTextField.text = "Old password field is empty"
                return false
            }
            alertChangButtonEnabled()
            return true
        }
        
        if textField == newPassrodTextField {
            if newPassrodTextField.text!.isEmpty {
                errorTextField.isHidden = false
                errorTextField.text = "New password field is empty"
                return false
            }
            alertChangButtonEnabled()
            return true
        }
        
        if textField == repeatNewPasswordTextField {
            if repeatNewPasswordTextField.text!.isEmpty {
                errorTextField.isHidden = false
                errorTextField.text = "Repeat New password field is empty"
                return false
            }
            alertChangButtonEnabled()
            return false
        }
        return true
    }
    
    func alertChangButtonEnabled() {
        if repeatNewPasswordTextField.text!.isEmpty || newPassrodTextField.text!.isEmpty || oldPasswordTextField.text!.isEmpty {
            errorTextField.text = ""
            return
        }
        
        if newPassrodTextField.text! != repeatNewPasswordTextField.text! {
            errorTextField.isHidden = false
            errorTextField.text = "Password do not match"
        } else {
            alertChangeButton.isEnabled = true
            errorTextField.isHidden = false
            errorTextField.text = ""
        }
    }
}
