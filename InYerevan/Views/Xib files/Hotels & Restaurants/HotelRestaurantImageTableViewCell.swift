//
//  HotelRestaurantImageTableViewCell.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/10/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class HotelRestaurantImageTableViewCell: UITableViewCell {
    static let id = "HotelRestaurantImageTableViewCell"
    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Other Properties
    var imagesUrl = [String]()
    var isHotel: Bool!
    var hotelViewController: HotelDescriptionViewController!
    var restaurantViewController: RestaurantDescriptionViewController!
    var hotelRestaurantImages = [UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //register TableViewCell
        collectionView.register(UINib(nibName: HotelRestaurantCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: HotelRestaurantCollectionViewCell.id)
    }
}

//MARK:- Images TableViewCell Delegate DataSource
extension HotelRestaurantImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isHotel {
            hotelViewController.imageHotel.image = hotelRestaurantImages[indexPath.row]
        } else {
            restaurantViewController.restaurantImage.image = hotelRestaurantImages[indexPath.row]
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let num = CGFloat(0)
        return UIEdgeInsets(top: num, left: num, bottom: num, right: num)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelRestaurantCollectionViewCell.id, for: indexPath) as! HotelRestaurantCollectionViewCell
        if imagesUrl.count != 0 {
            let url = URL(string: imagesUrl[indexPath.row])
            
            cell.image.sd_setIndicatorStyle(.white)
            cell.image.sd_setShowActivityIndicatorView(true)
            cell.image!.sd_setImage(with: url) { (image, error, _, _) in
                if error == nil {
                    cell.image.sd_setShowActivityIndicatorView(false)
                }
                self.hotelRestaurantImages.append(image!)
            }
        }
        return cell
    }
}
