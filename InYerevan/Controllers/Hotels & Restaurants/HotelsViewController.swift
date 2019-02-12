//
//  HotelsViewController.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/20/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class HotelsViewController: UIViewController {
    
    //MARK:- Interface Builder Outlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Other Properties
    var hotelsList = [HotelsType]()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hotels"
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        
        UIApplication.appDelegate.refHotels.observe(.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.hotelsList.removeAll()
                for hot in snapshot.children.allObjects as! [DataSnapshot] {
                    let hotelObject = hot.value as! [String: AnyObject]
                    let id = hotelObject["id"]
                    let name = hotelObject["hotelName"]
                    let star = hotelObject["hotelStar"]
                    let phoneNumber = hotelObject["hotelPhoneNumber"]
                    let openingHours = hotelObject["openingHoursHotel"]
                    let locationLong = hotelObject["hotelLocationLong"]
                    let locationlat = hotelObject["hotelLocationLat"]
                    let price = hotelObject["priceHotel"]
                    let rateSum = hotelObject["rateSum"]
                    let rateCount = hotelObject["rateCount"]
                    let urls = hotelObject["imageUrls"]
                    let rate = hotelObject["rate"]
                    
                    let hotels = HotelsType(id: id as! String, hotelName: name as! String, hotelStar: star as! String, hotelPhoneNumber: phoneNumber as! String, openingHoursHotel: openingHours as! String, hotelLocationLong: locationLong as! Double, hotelLocationLat: locationlat as! Double, priceHotel: price as! Double, hotelRateSum: rateSum as! Double, hotelRateCount: rateCount as! Int, hotelImageUrl: urls as! [String], hotelRate: rate as! Double)
                    self.hotelsList.append(hotels)
                }
            }
            self.hotelsList.sort()
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        navigationController?.isNavigationBarHidden = false
    }
}

//MARK:- TableView Delegate DataSource
extension HotelsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !hotelsList.isEmpty {
            let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HotelDescriptionViewControllerID") as! HotelDescriptionViewController
            vc.hotel = hotelsList[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HotelTableViewCell.id, for: indexPath) as! HotelTableViewCell
        if hotelsList.count != 0 {
            let url = URL(string: hotelsList[indexPath.row].hotelImageUrl[0])
            
            cell.nameHotel.text = hotelsList[indexPath.row].hotelName
            cell.starHotel.text = hotelsList[indexPath.row].hotelStar
            cell.imageHotel.sd_setIndicatorStyle(.white)
            cell.imageHotel.sd_setShowActivityIndicatorView(true)
            cell.imageHotel.sd_setImage(with: url) { (image, error, _, _) in
                if error == nil && image != nil {
                    cell.imageHotel.sd_setShowActivityIndicatorView(false)
                }
                
            }
        }
        return cell
    }
}
