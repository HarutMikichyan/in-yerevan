//
//  TopRestaurantTableViewCell.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/19/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class TopRestaurantTableViewCell: UITableViewCell {

    static let id = "TopRestaurantTableViewCell"
    
    @IBOutlet weak var topRestaurantCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topRestaurantCollectionView.delegate = self
        topRestaurantCollectionView.dataSource = self
    }
}

extension TopRestaurantTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRestaurantCollectionViewCell.id, for: indexPath)
        return cell
    }
}
