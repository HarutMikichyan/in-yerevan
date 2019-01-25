//
//  MainReserveViewController.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/19/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class MainReserveViewController: UIViewController {
    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainImage: UIImageView!
    
    //MARK:- Other Properties
    weak var topRestaurantCell: TopRestaurantTableViewCell!
    weak var topHotelCell: TopHotelTableViewCell!
    private var newHeaderLayer: CAShapeLayer!
    private let headerHeight: CGFloat = 218
    private var headerView: UIView!
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        view.changeBackgroundToGradient(from: [.black, .backgroundDarkSpruce, .backgroundDenimBlue])
        
        //register TableViewCell
        if User.isAdministration {
            tableView.register(UINib(nibName: ReserveRegistrationTableViewCell.id, bundle: nil), forCellReuseIdentifier: ReserveRegistrationTableViewCell.id)
        }
        tableView.register(UINib(nibName: CategoryTableViewCell.id, bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upDateView()
    }
    
    //MARK:- Main Image Animate Methods
    private func upDateView() {
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
    
    private func setupNewView() {
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
    
    //MARK:- Actions
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

//MARK:- TableView Delegate DataSource
extension MainReserveViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if User.isAdministration {
            tableView.deselectRow(at: indexPath, animated: true)
            switch indexPath.row {
            case 4:
                let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ReserveRegistrationViewControllerID") as! ReserveRegistrationViewController
                
                present(vc, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 218
        case 1:
            return 200
        case 2:
            return 200
        default:
            if User.isAdministration {
                return 60
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if User.isAdministration {
            return 4
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.id, for: indexPath) as! CategoryTableViewCell
            cell.parrentViewController = self
            cell.selectionStyle = .none
            return cell
        case 1:
            if topHotelCell == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: TopHotelTableViewCell.id, for: indexPath) as! TopHotelTableViewCell
                cell.selectionStyle = .none
                topHotelCell = cell
                topHotelCell.parrentViewController = self
            }
            return topHotelCell
        case 2:
            if topRestaurantCell == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: TopRestaurantTableViewCell.id, for: indexPath) as! TopRestaurantTableViewCell
                cell.selectionStyle = .none
                topRestaurantCell = cell
                topRestaurantCell.parrentViewController = self
            }
            return topRestaurantCell
        default:
            if User.isAdministration {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReserveRegistrationTableViewCell.id, for: indexPath) as! ReserveRegistrationTableViewCell
                return cell
            }
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if User.isAdministration {
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
}
