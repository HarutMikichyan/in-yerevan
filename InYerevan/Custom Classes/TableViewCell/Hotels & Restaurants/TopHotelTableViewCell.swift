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
    
    @IBOutlet weak var topHotelCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topHotelCollectionView.delegate = self
        topHotelCollectionView.dataSource = self
    }
}

extension TopHotelTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopHotelCollectionViewCell.id, for: indexPath) as! TopHotelCollectionViewCell
        return cell
    }
}
