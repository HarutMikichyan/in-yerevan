//
//  TopRestaurantTableViewCell.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/19/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class TopRestaurantTableViewCell: UITableViewCell {
    static let id = "TopRestaurantTableViewCell"
    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var topRestaurantCollectionView: UICollectionView!
    
    //MARK:- Other Properties
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
                    let urls = restaurantObject["imageUrls"]
                    let rate = restaurantObject["rate"]
                    
                    let restaurants = RestaurantsType(id: id as! String, restaurantName: name as! String, restaurantPhoneNumber: phoneNumber as! String, openingHoursRestaurant: openingHours as! String, restaurantLocationLong: locationLong as! Double, restaurantLocationLat: locationlat as! Double, priceRestaurant: price as! Double, restaurantRateSum: rateSum as! Double, restaurantRateCount: rateCount as! Int, restaurantImageUrl: urls as! [String], restaurantRate: rate as! Double)
                    self.restaurants.append(restaurants)
                    if self.restaurants.count == 10 {
                        break
                    }
                }
            }
            self.restaurants.sort()
            self.topRestaurantCollectionView.reloadData()
        }
    }
}

//MARK:- CollectionView Delegate DataSource
extension TopRestaurantTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RestaurantDescriptionViewControllerID") as! RestaurantDescriptionViewController
        vc.restaurant = restaurants[indexPath.row]
        
        parrentViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRestaurantCollectionViewCell.id, for: indexPath) as! TopRestaurantCollectionViewCell
        if restaurants.count != 0 {
            let url = URL(string: restaurants[indexPath.row].restaurantImageUrl[0])
            
            cell.topRestaurantsName.text = restaurants[indexPath.row].restaurantName
            cell.topRestaurantsImage.sd_setIndicatorStyle(.white)
            cell.topRestaurantsImage.sd_setShowActivityIndicatorView(true)
            cell.topRestaurantsImage.sd_setImage(with: url) { (_, error, _, _) in
                if error == nil {
                    cell.topRestaurantsImage.sd_setShowActivityIndicatorView(false)
                }
            }
        }
        return cell
    }
}
