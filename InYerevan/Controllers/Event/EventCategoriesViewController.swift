//
//  EventCategoiresViewController.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/16/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class EventCategoiresViewController: UIViewController {
    static let id = "EventCategoiresViewController"
    @IBOutlet weak var collectionView: UICollectionView!
    var eventCategories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        if let categories = UIApplication.dataManager.fetchCategories() {
            eventCategories = categories
        } else {
            let alert = UIAlertController(title: "Sorry", message: "No available Data, try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false 
    }

}

extension EventCategoiresViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventCategories.count
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count: CGFloat = 2
        let width: CGFloat =  collectionView.bounds.width / count - 16
        var height: CGFloat = collectionView.bounds.width / count - 16
        if indexPath.row == 0 {
            height =  height + height / 2
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCategoryCollectionViewCell.id, for: indexPath) as! EventCategoryCollectionViewCell
        let category = eventCategories[indexPath.row]
        //TODO: Fetch Picture from first event and show it!
        let picture = (category.events?.allObjects.first as? Event)?.pictureURL
        cell.prepareCellWith(label: category.name!, background: #imageLiteral(resourceName: "Technology"))
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: EventsViewController.id) as! EventsViewController
        vc.events =  eventCategories[indexPath.row].events?.allObjects as! [Event]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
