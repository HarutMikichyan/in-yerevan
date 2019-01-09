//
//  MainReserveViewController.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/19/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase

class MainReserveViewController: UIViewController {
    
    static var hotelsList = [HotelModel]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainImage: UIImageView!
    var headerView: UIView!
    var newHeaderLayer: CAShapeLayer!
    private let headerHeight: CGFloat = 218
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        
        UIApplication.appDelegate.refHotels.observe(.value) { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                MainReserveViewController.hotelsList.removeAll()
                for hot in snapshot.children.allObjects as! [DataSnapshot] {
                    let hotelObject = hot.value as! [String: AnyObject]
                    let id = hotelObject["id"]
                    let name = hotelObject["hotelName"]
                    let star = hotelObject["hotelStar"]
                    let phoneNumber = hotelObject["hotelPhoneNumber"]
                    let openingHours = hotelObject["openingHoursHotel"]
                    let location = hotelObject["hotelLocation"]
                    
                    
                    let hotel = HotelModel(id: id as! String, hotelName: name as! String, hotelStar: star as! String, hotelPhoneNumber: phoneNumber as! String, openingHoursHotel: openingHours as! String, hotelLocation: location as! String)
                    
                    MainReserveViewController.hotelsList.append(hotel)
                }
            }
        }
        
        tableView.register(UINib(nibName: ReserveRegistrationTableViewCell.id, bundle: nil), forCellReuseIdentifier: ReserveRegistrationTableViewCell.id)
        tableView.register(UINib(nibName: CategoryTableViewCell.id, bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.id)
        
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upDateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        navigationController?.isNavigationBarHidden = true
    }
    
    // Main Image Animate Methods
    func upDateView() {
        tableView.backgroundColor = .white
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        newHeaderLayer = CAShapeLayer()
        newHeaderLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = newHeaderLayer
        
        let newHeight = headerHeight - headerHeight / 10
        tableView.contentInset = UIEdgeInsets(top: newHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -newHeight)
        
        setupNewView()
    }
    
    func setupNewView() {
        let newheight = headerHeight - headerHeight / 10
        var getHeaderFrame = CGRect(x: 0, y: -newheight, width: tableView.bounds.width, height: headerHeight)
        if tableView.contentOffset.y < newheight {
            getHeaderFrame.origin.y = tableView.contentOffset.y
            getHeaderFrame.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = getHeaderFrame
        let cutDirection = UIBezierPath()
        cutDirection.move(to: CGPoint(x: 0, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: getHeaderFrame.height))
        cutDirection.addLine(to: CGPoint(x: 0, y: getHeaderFrame.height
        ))
        newHeaderLayer.path = cutDirection.cgPath
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.setupNewView()
    }
    
    @IBAction func seeAllHotels(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HotelsViewControllerID")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func seeAllRestaurants(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RestaurantsViewControllerID")
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainReserveViewController: UITableViewDelegate, UITableViewDataSource {
    
    //TableView Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 218
        case 1:
            return 60
        default:
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.id, for: indexPath) as! CategoryTableViewCell
            cell.parrentViewController = self
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReserveRegistrationTableViewCell.id, for: indexPath) as! ReserveRegistrationTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: TopHotelTableViewCell.id, for: indexPath) as! TopHotelTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TopRestaurantTableViewCell.id, for: indexPath) as! TopRestaurantTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
            let vc =  storyboard.instantiateViewController(withIdentifier: "ReserveRegistrationViewControllerID")
            navigationController?.present(vc, animated: true, completion: nil)
        default:
            break
        }
    }
}
