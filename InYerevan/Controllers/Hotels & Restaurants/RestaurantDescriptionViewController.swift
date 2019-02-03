//
//  RestaurantDescriptionViewController.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/21/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class RestaurantDescriptionViewController: UIViewController {
    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    
    //MARK:- Other Properties
    var restaurantImageCell: HotelRestaurantImageTableViewCell!
    var restaurant: RestaurantsType!
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        restaurantName.text = restaurant.restaurantName
        
        //register TableViewCell
        tableView.register(UINib(nibName: HotelRestaurantImageTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelRestaurantImageTableViewCell.id)
        tableView.register(UINib(nibName: RestaurantOverviewTableViewCell.id, bundle: nil), forCellReuseIdentifier: RestaurantOverviewTableViewCell.id)
        tableView.register(UINib(nibName: HotelRestaurantMapTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelRestaurantMapTableViewCell.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- Action
    @IBAction func segmentControll(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.setContentOffset(.zero, animated: true)
        case 1:
            tableView.setContentOffset(CGPoint(x: 0, y: 355), animated: true)
        default:
            fatalError()
        }
    }
}

//MARK:- TableView Delgate DataSource
extension RestaurantDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 130
        case 1:
            return 225
        default:
            return 380
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if restaurantImageCell == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: HotelRestaurantImageTableViewCell.id, for: indexPath) as! HotelRestaurantImageTableViewCell
                cell.selectionStyle = .none
                cell.imagesUrl = self.restaurant.restaurantImageUrl
                cell.isHotel = false
                cell.restaurantViewController = self
                restaurantImageCell = cell
            }
            return restaurantImageCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantOverviewTableViewCell.id, for: indexPath) as! RestaurantOverviewTableViewCell
            cell.restaurantPhoneNumber.text = restaurant.restaurantPhoneNumber
            cell.restaurantOpeningHours.text = restaurant.openingHoursRestaurant
            cell.restaurantId = restaurant.id
            cell.resPrice = restaurant.priceRestaurant
            cell.restaurantRateCount = restaurant.restaurantRateCount
            cell.restaurantRatesSum = restaurant.restaurantRateSum
            cell.restaurantRate = restaurant.restaurantRate
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelRestaurantMapTableViewCell.id, for: indexPath) as! HotelRestaurantMapTableViewCell
            cell.textMap.text = "Restaurant Location"
            cell.locationLat = restaurant.restaurantLocationLat
            cell.locationLong = restaurant.restaurantLocationLong
            cell.name = restaurant.restaurantName
            cell.openingHours = restaurant.openingHoursRestaurant
            return cell
        default:
            fatalError()
        }
    }
}
