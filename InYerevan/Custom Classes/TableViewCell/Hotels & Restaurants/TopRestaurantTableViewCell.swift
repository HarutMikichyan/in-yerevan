//
//  TopRestaurantTableViewCell.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/19/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase

class TopRestaurantTableViewCell: UITableViewCell {
    static let id = "TopRestaurantTableViewCell"
    
    @IBOutlet weak var topRestaurantCollectionView: UICollectionView!
    var parrentViewController: UIViewController!
    private var restaurants = [RestaurantsType]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topRestaurantCollectionView.delegate = self
        topRestaurantCollectionView.dataSource = self
        
        UIApplication.appDelegate.refRestaurants.observe(.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.restaurants.removeAll()
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
                    
                    let restaurants = RestaurantsType(id: id as! String, restaurantName: name as! String, restaurantPhoneNumber: phoneNumber as! String, openingHoursRestaurant: openingHours as! String, restaurantLocationLong: locationLong as! Double, restaurantLocationLat: locationlat as! Double, priceRestaurant: price as! Double, restaurantRateSum: rateSum as! Double, restaurantRateCount: rateCount as! Int)
                    self.restaurants.append(restaurants)
                    if self.restaurants.count == 10 {
                        break
                    }
                }
            }
            self.topRestaurantCollectionView.reloadData()
        }
    }
}

extension TopRestaurantTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RestaurantDescriptionViewControllerID") as! RestaurantDescriptionViewController
        vc.restaurant = restaurants[indexPath.row]
        
        parrentViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRestaurantCollectionViewCell.id, for: indexPath) as! TopRestaurantCollectionViewCell
        if restaurants.count != 0 {
            cell.topRestaurantsName.text = restaurants[indexPath.row].restaurantName
        }
        return cell
    }
}
