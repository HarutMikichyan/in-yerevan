//
//  TopHotelTableViewCell.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/19/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class TopHotelTableViewCell: UITableViewCell {
    
    static let id = "TopHotelTableViewCell"
    
    private var hotels = [TopHotelsType]()
    
    @IBOutlet weak var topHotelCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topHotelCollectionView.delegate = self
        topHotelCollectionView.dataSource = self
    }
    
    func setUp(with hotels: [TopHotelsType]) {
        self.hotels = hotels
        topHotelCollectionView.reloadData()
    }
}

extension TopHotelTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        topHotelCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopHotelCollectionViewCell.id, for: indexPath) as! TopHotelCollectionViewCell
        if hotels.count != 0 {
            cell.topHotelsName.text = hotels[indexPath.row].hotelName
        }
        return cell
    }
}
