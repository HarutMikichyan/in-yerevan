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
    
    private let refStorage = Storage.storage().reference()
    var images = [UIImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet var hotelRegistrationView: UIView!
    @IBOutlet var restaurantRegistrationView: UIView!
    
    //MARK: -TextField Outlet
    // hotel outlet
    @IBOutlet weak var hotelName: UITextField!
    @IBOutlet weak var hotelStar: UITextField!
    @IBOutlet weak var hotelPhoneNumber: UITextField!
    @IBOutlet weak var openingHoursHotel: UITextField!
    @IBOutlet weak var priceHotel: UITextField!
    @IBOutlet weak var hotelLocation: UIMapInputTextField!
    
    //restaurant outlet
    @IBOutlet weak var restaurantName: UITextField!
    @IBOutlet weak var restaurantPhoneNumber: UITextField!
    @IBOutlet weak var openingHoursRestaurant: UITextField!
    @IBOutlet weak var priceRestaurant: UITextField!
    @IBOutlet weak var restaurantLocation: UIMapInputTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageButton.layer.cornerRadius = 12
        imageButton.clipsToBounds = true
        registrationView.addSubview(hotelRegistrationView)
        hotelRegistrationView.frame = registrationView.bounds
        
        //registration View layer
        registrationView.layer.cornerRadius = 12
        registrationView.clipsToBounds = true
        registrationView.layer.borderWidth = 2
        registrationView.layer.borderColor = UIColor.blue.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        //registration View layer
        registrationView.layer.cornerRadius = 12
        registrationView.clipsToBounds = true
        registrationView.layer.borderWidth = 2
        registrationView.layer.borderColor = UIColor.blue.cgColor
    }
    
    @IBAction func segmentControllRegistration(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            restaurantRegistrationView.removeFromSuperview()
            registrationView.addSubview(hotelRegistrationView)
            hotelRegistrationView.frame = registrationView.bounds
        case 1:
            hotelRegistrationView.removeFromSuperview()
            registrationView.addSubview(restaurantRegistrationView)
            restaurantRegistrationView.frame = registrationView.bounds
        default:
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addHotel(_ sender: Any) {
        
        if hotelName.text != "" && hotelStar.text != "" && hotelPhoneNumber.text != ""
            && openingHoursHotel.text != "" && hotelLocation.text != "" && priceHotel.text != "" {
//             && images.count > 0
    
            //realTime Firebase
            let keyHotel: String = UIApplication.appDelegate.refHotels.childByAutoId().key!
            
            let hotLoc: (lat: Double, long: Double) = self.hotelLocation.getCoordinatesAsTuple()
            let rateSum: Double = 0.0
            let rateCount: Int = 0
            guard let priceHot = Double(priceHotel.text!) else { return }
            
            let hotel: [String: Any] = ["id": keyHotel, "hotelName": hotelName.text! , "hotelStar": hotelStar.text! , "hotelPhoneNumber": hotelPhoneNumber.text! , "openingHoursHotel": openingHoursHotel.text!, "hotelLocationLong": hotLoc.long , "hotelLocationLat": hotLoc.lat, "priceHotel": priceHot, "rateSum": rateSum, "rateCount": rateCount]
            
            UIApplication.appDelegate.refHotels.child(keyHotel).setValue(hotel)
            
            //storage Firebase
//            for img in 0...images.count - 1 {
//                saveFirebaseStorage(images[img], to: keyHotel) { (url) in
//                    if url != nil {
//                        print()
//                    }
//                }
//            }
        }
    }
    
    private func saveFirebaseStorage(_ image: UIImage, to hotelID: String?, completion: @escaping (URL?) -> Void) {
         guard let id = hotelID else {
            completion(nil)
            return
        }
        guard let scaledImage = image.scaledToSafeUploadSize,
            let data = scaledImage.jpegData(compressionQuality: 0.4) else {
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
    
//    func saveFirebaseStorage() {
//        for img in images {
//            guard let scaledImage = img.scaledToSafeUploadSize,
//                let data = scaledImage.jpegData(compressionQuality: 0.4) else {
//                    completion(nil)
//                    return
//            }
//        }
//    }
    
    @IBAction func addRestaurant(_ sender: Any) {
        if restaurantName.text != "" && restaurantPhoneNumber.text != ""
            && openingHoursRestaurant.text != "" && restaurantLocation.text != ""  && priceRestaurant.text != "" {
            
            let keyRestaurant: String = UIApplication.appDelegate.refRestaurants.childByAutoId().key!
            let resLoc: (lat: Double, long: Double) = self.restaurantLocation.getCoordinatesAsTuple()
            let rateSum: Double = 0.0
            let rateCount: Int = 0
            guard let priceRes = Double(priceRestaurant.text!) else { return }
            
            let restaurant: [String: Any] = ["id": keyRestaurant, "restaurantName": restaurantName.text!, "restaurantPhoneNumber": restaurantPhoneNumber.text!, "openingHoursRestaurant": openingHoursRestaurant.text!, "restaurantLocationLong": resLoc.long, "restaurantLocationLat": resLoc.lat, "priceRestaurant": priceRes, "rateSum": rateSum, "rateCount": rateCount]
            
            UIApplication.appDelegate.refRestaurants.child(keyRestaurant).setValue(restaurant)
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        let vc = ImagePickerViewController()
        present(vc, animated: true, completion: nil)
        vc.delegate = self
    }
}

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
