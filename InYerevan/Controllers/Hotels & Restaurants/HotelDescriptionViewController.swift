//
//  HotelDescriptionViewController.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/20/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class HotelDescriptionViewController: UIViewController {

     var imageHotel = ["hotelImage1", "hotelImage2"]
    
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func callHotel(_ sender: Any) {
        let theButton = sender as! UIButton
        let baunds = theButton.bounds
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            theButton.bounds = CGRect(x: baunds.origin.x - 20, y: baunds.origin.y, width: baunds.size.width + 60, height: baunds.size.height)
        }, completion: { (success: Bool) in
            if success {
                theButton.bounds = baunds
            }
        })
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.setContentOffset(.zero, animated: true)
        case 1:
            tableView.setContentOffset(CGPoint(x: 0, y: 290), animated: true)
        case 2:
            tableView.setContentOffset(CGPoint(x: 0, y: 690), animated: true)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       navigationController?.isNavigationBarHidden = false
       pageControl.numberOfPages = imageHotel.count
    
        tableView.register(UINib(nibName: HotelOverviewTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelOverviewTableViewCell.id)
        tableView.register(UINib(nibName: HotelMapTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelMapTableViewCell.id)
        tableView.register(UINib(nibName: HotelReviewsTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelReviewsTableViewCell.id)
    }
}

extension HotelDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 290
        case 1:
            return 400
        case 2:
            return 290
        default:
            return 34
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelOverviewTableViewCell.id, for: indexPath) as! HotelOverviewTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelMapTableViewCell.id, for: indexPath) as! HotelMapTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelReviewsTableViewCell.id, for: indexPath) as! HotelReviewsTableViewCell
            return cell
        }
    }
}
