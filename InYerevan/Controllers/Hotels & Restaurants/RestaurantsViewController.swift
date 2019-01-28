//
//  RestaurantsViewController.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/20/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase

class RestaurantsViewController: UIViewController {

    //MARK:- Interface Builder Outlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Other Properties
    var restaurantsList = [RestaurantsType]()
    var images = [UIImage]()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Restaurants"
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        
        UIApplication.appDelegate.refRestaurants.observe(.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.restaurantsList.removeAll()
                for res in snapshot.children.allObjects as! [DataSnapshot] {
                    let restaurantObject = res.value as! [String: AnyObject]
                    let id = restaurantObject["id"]
                    let name = restaurantObject["restaurantName"]
                    let phoneNumber = restaurantObject["restaurantPhoneNumber"]
                    let openingHours = restaurantObject["openingHoursRestaurant"]
                    let locationLong = restaurantObject["restaurantLocationLong"]
                    let locationlat = restaurantObject["restaurantLocationLat"]
                    let price = restaurantObject["priceRestaurant"]
                    let rateSum = restaurantObject["rateSum"]
                    let rateCount = restaurantObject["rateCount"]
                    let urls = restaurantObject["imageUrls"]
                    let rate = restaurantObject["rate"]

                    let restaurants = RestaurantsType(id: id as! String, restaurantName: name as! String, restaurantPhoneNumber: phoneNumber as! String, openingHoursRestaurant: openingHours as! String, restaurantLocationLong: locationLong as! Double, restaurantLocationLat: locationlat as! Double, priceRestaurant: price as! Double, restaurantRateSum: rateSum as! Double, restaurantRateCount: rateCount as! Int, restaurantImageUrl: urls as! [String], restaurantRate: rate as! Double)
                    self.restaurantsList.append(restaurants)
                }
            }
        }
        self.restaurantsList.sort()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- Storage Private Method
    private func downloadImage(at urls: String, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: urls)
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(UIImage(data: imageData))
            }
        }
    }
}

//MARk:- TableView Delegate DataSource
extension RestaurantsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RestaurantDescriptionViewControllerID") as! RestaurantDescriptionViewController
        vc.restaurant = restaurantsList[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.id, for: indexPath) as! RestaurantTableViewCell
        if restaurantsList.count != 0 {
            cell.nameRestaurant.text = restaurantsList[indexPath.row].restaurantName
            cell.priceRestaurant.text = String(restaurantsList[indexPath.row].priceRestaurant)
            if self.images.count <= indexPath.row {
                DispatchQueue.main.async {
                    self.downloadImage(at: self.restaurantsList[indexPath.row].restaurantImageUrl[0], completion: { (image) in
                        guard let image = image else { return }
                        
                        cell.imageRestaurant.image = image
                        self.images.append(image)
                    })
                }
            } else {
                cell.imageRestaurant.image = self.images[indexPath.row]
            }
        }
        return cell
    }
}
