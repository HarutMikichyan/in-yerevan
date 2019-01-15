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

    var restaurantsList = [RestaurantsType]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Restaurants"
        
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

                    let restaurants = RestaurantsType(id: id as! String, restaurantName: name as! String, restaurantPhoneNumber: phoneNumber as! String, openingHoursRestaurant: openingHours as! String, restaurantLocationLong: locationLong as! Double, restaurantLocationLat: locationlat as! Double)
                    self.restaurantsList.append(restaurants)

                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        navigationController?.isNavigationBarHidden = false
    }
}

extension RestaurantsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RestaurantDescriptionViewControllerID") as! RestaurantDescriptionViewController
        vc.restaurant = restaurantsList[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.id, for: indexPath) as! RestaurantTableViewCell
        if restaurantsList.count != 0 {
           cell.nameRestaurant.text = restaurantsList[indexPath.row].restaurantName
        }
        return cell
    }
}
