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
    
     var hotel: HotelsType!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            break
        }
    }
}

extension HotelDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 300
        default:
            return 450
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelOverviewTableViewCell.id, for: indexPath) as! HotelOverviewTableViewCell
            cell.hotelPhoneNumber.text = hotel.hotelPhoneNumber
            cell.ratelbl.text = hotel.hotelStar
            cell.openingHours.text = hotel.openingHoursHotel
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
