//
//  TopHotelTableViewCell.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/19/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase

class TopHotelTableViewCell: UITableViewCell {
    static let id = "TopHotelTableViewCell"
    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var topHotelCollectionView: UICollectionView!
    
    //MARK:- Other Properties
    var parrentViewController: UIViewController!
    var images = [UIImage]()
    private var hotels = [HotelsType]()
   
    override func awakeFromNib() {
        super.awakeFromNib()
        topHotelCollectionView.delegate = self
        topHotelCollectionView.dataSource = self
        self.backgroundColor = .clear
        UIApplication.appDelegate.refHotels.queryOrdered(byChild: "rate").observe(.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.hotels.removeAll()
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
                    self.hotels.append(hotels)
                    if self.hotels.count == 10 {
                        break
                    }
                    self.topHotelCollectionView.reloadData()
                }
            } 
        }
    }
    
    //MARK:- Storage Private Method
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

//MARK:- CollectionView Delegate DataSource
extension TopHotelTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HotelDescriptionViewControllerID") as! HotelDescriptionViewController
        vc.hotel = hotels[indexPath.row]
        
        parrentViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopHotelCollectionViewCell.id, for: indexPath) as! TopHotelCollectionViewCell
        if hotels.count != 0 {
            cell.topHotelsName.text = hotels[indexPath.row].hotelName
            if self.images.count <= indexPath.row {
                DispatchQueue.main.async {
                    self.downloadImage(at: self.hotels[indexPath.row].hotelImageUrl[0], completion: { (image) in
                        guard let image = image else { return }
                        
                        cell.topHotelsImage.image = image
                        self.images.append(image)
                    })
                }
            } else {
                cell.topHotelsImage.image = self.images[indexPath.row]
            }
        }
        return cell
    }
}
