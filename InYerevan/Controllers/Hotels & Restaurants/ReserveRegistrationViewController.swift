//
//  ReserveRegistrationViewController.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/8/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit
import Firebase

class ReserveRegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet var hotelRegistrationView: UIView!
    @IBOutlet var restaurantRegistrationView: UIView!

    //hotel outlets
    @IBOutlet weak var hotelName: UITextField!
    @IBOutlet weak var hotelStar: UITextField!
    @IBOutlet weak var hotelPhoneNumber: UITextField!
    @IBOutlet weak var openingHoursHotel: UITextField!
    @IBOutlet weak var priceHotel: UITextField!
    @IBOutlet weak var hotelLocation: UIMapInputTextField!
    
    //restaurant outlets
    @IBOutlet weak var restaurantName: UITextField!
    @IBOutlet weak var restaurantPhoneNumber: UITextField!
    @IBOutlet weak var openingHoursRestaurant: UITextField!
    @IBOutlet weak var priceRestaurant: UITextField!
    @IBOutlet weak var restaurantLocation: UIMapInputTextField!
    
    //MARK:- Other Properties
    private let refStorage = Storage.storage().reference()
    private var images = [UIImage]()
    private var isSubView = true
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        imageButton.layer.cornerRadius = 12
        imageButton.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //registration View layer
        registrationView.layer.cornerRadius = 12
        registrationView.clipsToBounds = true
        registrationView.layer.borderWidth = 2
        registrationView.layer.borderColor = UIColor.outgoingLavender.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isSubView {
            registrationView.addSubview(hotelRegistrationView)
            hotelRegistrationView.frame = registrationView.bounds
            isSubView = false
        }
    }
    
    // MARK:- Actions
    @IBAction func segmentControllRegistration(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            restaurantRegistrationView.removeFromSuperview()
            registrationView.addSubview(hotelRegistrationView)
            hotelRegistrationView.frame = registrationView.bounds
            images.removeAll()
        case 1:
            hotelRegistrationView.removeFromSuperview()
            registrationView.addSubview(restaurantRegistrationView)
            restaurantRegistrationView.frame = registrationView.bounds
            images.removeAll()
        default:
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addHotel(_ sender: Any) {
        if hotelName.text != "" && hotelStar.text != "" && hotelPhoneNumber.text != "" && openingHoursHotel.text != "" && hotelLocation.text != "" && priceHotel.text != "" && images.count > 0 {
    
            //realTime Firebase
            let keyHotel: String = UIApplication.appDelegate.refHotels.childByAutoId().key!
            
            let hotLoc: (lat: Double, long: Double) = self.hotelLocation.getCoordinatesAsTuple()
            let rateSum: Double = 0.0
            let rateCount: Int = 0
            let rate: Double = 0.0
            guard let priceHot = Double(priceHotel.text!) else { return }
            var urls: [String] = []
            
            //storage Firebase
            for img in 0...images.count - 1 {
                saveFirebaseStorage(images[img], to: keyHotel) { (url) in
                    if url != nil {
                        urls.append(url!.absoluteString)
                        if urls.count == self.images.count {
                            //RealTime Database
                            let hotel: [String: Any] = ["id": keyHotel, "hotelName": self.hotelName.text! , "hotelStar": self.hotelStar.text! , "hotelPhoneNumber": self.hotelPhoneNumber.text! , "openingHoursHotel": self.openingHoursHotel.text!, "hotelLocationLong": hotLoc.long , "hotelLocationLat": hotLoc.lat, "priceHotel": priceHot, "rateSum": rateSum, "rateCount": rateCount, "imageUrls": urls, "rate": rate]
                            UIApplication.appDelegate.refHotels.child(keyHotel).setValue(hotel)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func addRestaurant(_ sender: Any) {
        if restaurantName.text != "" && restaurantPhoneNumber.text != ""
            && openingHoursRestaurant.text != "" && restaurantLocation.text != ""  && priceRestaurant.text != ""  && images.count > 0 {
            
            let keyRestaurant: String = UIApplication.appDelegate.refRestaurants.childByAutoId().key!
            let resLoc: (lat: Double, long: Double) = self.restaurantLocation.getCoordinatesAsTuple()
            let rateSum: Double = 0.0
            let rateCount: Int = 0
            let rate: Double = 0.0
            guard let priceRes = Double(priceRestaurant.text!) else { return }
            var urls: [String] = []
            
            //storage Firebase
            for img in 0...images.count - 1 {
                saveFirebaseStorage(images[img], to: keyRestaurant) { (url) in
                    if url != nil {
                        urls.append(url!.absoluteString)
                        if urls.count == self.images.count {
                            //RealTime database
                            let restaurant: [String: Any] = ["id": keyRestaurant, "restaurantName": self.restaurantName.text!, "restaurantPhoneNumber": self.restaurantPhoneNumber.text!, "openingHoursRestaurant": self.openingHoursRestaurant.text!, "restaurantLocationLong": resLoc.long, "restaurantLocationLat": resLoc.lat, "priceRestaurant": priceRes, "rateSum": rateSum, "rateCount": rateCount , "imageUrls": urls, "rate": rate]
                            UIApplication.appDelegate.refRestaurants.child(keyRestaurant).setValue(restaurant)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        let vc = ImagePickerViewController()
        present(vc, animated: true, completion: nil)
        vc.delegate = self
    }
    
    //MARK:- Storage Private Methods
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: imageData))
        }
    }

    private func saveFirebaseStorage(_ image: UIImage, to hotelID: String?, completion: @escaping (URL?) -> Void) {
        
        guard let scaledImage = image.scaledToSafeUploadSize,
              let data = scaledImage.jpegData(compressionQuality: 0.4),
              let id  = hotelID else {
                completion(nil)
                return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        
        refStorage.child(id).child(imageName).putData(data, metadata: metadata) { meta, error in
            if let error = error {
                print(error)
            }
            
            self.refStorage.child(id).child(imageName).downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error as Any)
                } else {
                    guard let imageURL = url?.absoluteURL else { return }
                    completion(imageURL)
                }
            })
        }
    }
}

//MARK:- CollectionView Delegate
extension ReserveRegistrationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelRestaurantImagePickerCollectionViewCell.id, for: indexPath) as! HotelRestaurantImagePickerCollectionViewCell
        cell.imagePicker.image = images[indexPath.row]
        return cell
    }
}

//MARK:- Image Picker Delegate
extension ReserveRegistrationViewController: ImagePickerViewControllerDelegate {
    
    func didSelectedItem(image: UIImage?) {
        if image != nil {
            images.append(image!)
            collectionView.reloadData()
        }
    }
    
    func didDeselectedItem(image: UIImage?) {
        if image != nil {
            for index in 0..<images.count {
                if image! == images[index] {
                    images.remove(at: index)
                    collectionView.reloadData()
                    break
                }
            }
        }
    }
}
