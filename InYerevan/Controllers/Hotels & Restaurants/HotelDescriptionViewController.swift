//
//  HotelDescriptionViewController.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/20/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase

class HotelDescriptionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var hotel: HotelsType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        
        //register TableViewCell
        tableView.register(UINib(nibName: HotelRestaurantImageTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelRestaurantImageTableViewCell.id)
        tableView.register(UINib(nibName: HotelOverviewTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelOverviewTableViewCell.id)
        tableView.register(UINib(nibName: HotelRestaurantMapTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelRestaurantMapTableViewCell.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.setContentOffset(.zero, animated: true)
        case 1:
            tableView.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
        default:
            fatalError()
        }
    }
}

extension HotelDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 240
        case 1:
            return 300
        default:
            return 450
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelRestaurantImageTableViewCell.id, for: indexPath) as! HotelRestaurantImageTableViewCell
            cell.textPhotos.text = "Hotel Photos"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelOverviewTableViewCell.id, for: indexPath) as! HotelOverviewTableViewCell
            cell.hotelPhoneNumber.text = hotel.hotelPhoneNumber
            cell.star.text = hotel.hotelStar
            cell.hotPrice = hotel.priceHotel
            cell.openingHours.text = hotel.openingHoursHotel
            cell.hotelId = hotel.id
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelRestaurantMapTableViewCell.id, for: indexPath) as! HotelRestaurantMapTableViewCell
            cell.textMap.text = "Hotel Location"
            cell.locationLong = hotel.hotelLocationLong
            cell.locationLat = hotel.hotelLocationLat
            cell.name = hotel.hotelName
            cell.openingHours = hotel.openingHoursHotel
            return cell
        }
    }
}
