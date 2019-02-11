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
    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageHotel: UIImageView!
    @IBOutlet weak var nameHotel: UILabel!
    
    //MARK:- Other Properties
    weak var hotelImagesCell: HotelRestaurantImageTableViewCell!
    var hotel: HotelsType!
    var images = [UIImage]()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        nameHotel.text = hotel.hotelName
        
        //register TableViewCell
        tableView.register(UINib(nibName: HotelRestaurantImageTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelRestaurantImageTableViewCell.id)
        tableView.register(UINib(nibName: HotelOverviewTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelOverviewTableViewCell.id)
        tableView.register(UINib(nibName: HotelRestaurantMapTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelRestaurantMapTableViewCell.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- Action
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.setContentOffset(.zero, animated: true)
        case 1:
            tableView.setContentOffset(CGPoint(x: 0, y: 430), animated: true)
        default:
            fatalError()
        }
    }
}

//MARK:- TableView Delgate DataSource
extension HotelDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 130
        case 1:
            return 300
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
            if hotelImagesCell == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: HotelRestaurantImageTableViewCell.id, for: indexPath) as! HotelRestaurantImageTableViewCell
                cell.selectionStyle = .none
                cell.imagesUrl = self.hotel.hotelImageUrl
                cell.isHotel = true
                cell.hotelViewController = self
                hotelImagesCell = cell
            }
            return hotelImagesCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelOverviewTableViewCell.id, for: indexPath) as! HotelOverviewTableViewCell
            cell.hotelPhoneNumber.text = hotel.hotelPhoneNumber
            cell.star.text = hotel.hotelStar
            cell.hotPrice = hotel.priceHotel
            cell.openingHours.text = hotel.openingHoursHotel
            cell.hotelId = hotel.id
            cell.hotelRateCount = hotel.hotelRateCount
            cell.hotelRatesSum = hotel.hotelRateSum
            cell.hotelRate = hotel.hotelRate
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
