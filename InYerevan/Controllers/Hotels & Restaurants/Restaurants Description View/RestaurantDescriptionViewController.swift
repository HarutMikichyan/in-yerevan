//
//  RestaurantDescriptionViewController.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/21/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class RestaurantDescriptionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        navigationController?.isNavigationBarHidden = false
        
        tableView.register(UINib(nibName: HotelOverviewTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelOverviewTableViewCell.id)
        tableView.register(UINib(nibName: HotelRestaurantMapTableViewCell.id, bundle: nil), forCellReuseIdentifier: HotelRestaurantMapTableViewCell.id)
    }
    
    @IBAction func segmentControll(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.setContentOffset(.zero, animated: true)
        case 1:
            tableView.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
        default:
            fatalError()
        }
    }
}

extension RestaurantDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 300
        case 1:
            return 450
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelOverviewTableViewCell.id, for: indexPath) as! HotelOverviewTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelRestaurantMapTableViewCell.id, for: indexPath) as! HotelRestaurantMapTableViewCell
            cell.textMap.text = "Restaurant Location"
            return cell
        default:
            fatalError()
        }
    }
}
