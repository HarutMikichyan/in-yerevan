//
//  RestaurantDescriptionViewController.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/21/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class RestaurantDescriptionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var restaurant: RestaurantsType!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        navigationController?.isNavigationBarHidden = false
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        
        //register TableViewCell
        tableView.register(UINib(nibName: HotelRestaurantImageTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelRestaurantImageTableViewCell.id)
        tableView.register(UINib(nibName: RestaurantOverviewTableViewCell.id, bundle: nil), forCellReuseIdentifier: RestaurantOverviewTableViewCell.id)
        tableView.register(UINib(nibName: HotelRestaurantMapTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelRestaurantMapTableViewCell.id)
    }
    
    @IBAction func segmentControll(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.setContentOffset(.zero, animated: true)
        case 1:
            tableView.setContentOffset(CGPoint(x: 0, y: 225), animated: true)
        default:
            fatalError()
        }
    }
}

extension RestaurantDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 240
        case 1:
            return 225
        case 2:
            return 450
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelRestaurantImageTableViewCell.id, for: indexPath) as! HotelRestaurantImageTableViewCell
            cell.textPhotos.text = "Restaurant Photos"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantOverviewTableViewCell.id, for: indexPath) as! RestaurantOverviewTableViewCell
            cell.restaurantPhoneNumber.text = restaurant.restaurantPhoneNumber
            cell.restaurantOpeningHours.text = restaurant.openingHoursRestaurant
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelRestaurantMapTableViewCell.id, for: indexPath) as! HotelRestaurantMapTableViewCell
            cell.textMap.text = "Restaurant Location"
            return cell
        default:
            fatalError()
        }
    }
}
