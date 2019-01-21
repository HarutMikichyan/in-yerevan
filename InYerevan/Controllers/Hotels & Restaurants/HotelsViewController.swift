//
//  HotelsViewController.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/20/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase

class HotelsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var hotelsList = [HotelsType]()
    var images = [UIImage]()
    
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
                    
                    let hotels = HotelsType(id: id as! String, hotelName: name as! String, hotelStar: star as! String, hotelPhoneNumber: phoneNumber as! String, openingHoursHotel: openingHours as! String, hotelLocationLong: locationLong as! Double, hotelLocationLat: locationlat as! Double, priceHotel: price as! Double, hotelRateSum: rateSum as! Double, hotelRateCount: rateCount as! Int, hotelImageUrl: urls as! [String])
                    self.hotelsList.append(hotels)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        navigationController?.isNavigationBarHidden = false
    }
    
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

extension HotelsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HotelDescriptionViewControllerID") as! HotelDescriptionViewController
        vc.hotel = hotelsList[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HotelTableViewCell.id, for: indexPath) as! HotelTableViewCell
        if hotelsList.count != 0 {
            cell.nameHotel.text = hotelsList[indexPath.row].hotelName
            cell.starHotel.text = hotelsList[indexPath.row].hotelStar
            if self.images.count <= indexPath.row {
                DispatchQueue.main.async {
                    self.downloadImage(at: self.hotelsList[indexPath.row].hotelImageUrl[0], completion: { (image) in
                        guard let image = image else { return }
                        
                        cell.imageHotel.image = image
                        self.images.append(image)
                    })
                }
            } else {
                cell.imageHotel.image = self.images[indexPath.row]
            }
        }
        return cell
    }
}
