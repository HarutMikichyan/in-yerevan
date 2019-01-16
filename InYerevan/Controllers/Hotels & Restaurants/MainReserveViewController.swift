//
//  MainReserveViewController.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/19/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
//import FirebaseFirestore
//import Firebase

class MainReserveViewController: UIViewController {
    
//    private let refStorage = Storage.storage().reference()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainImage: UIImageView!
    
    var headerView: UIView!
    var newHeaderLayer: CAShapeLayer!
    weak var topHotelCell: TopHotelTableViewCell!
    weak var topRestaurantCell: TopRestaurantTableViewCell!
    
    private let headerHeight: CGFloat = 218
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        
        tableView.register(UINib(nibName: ReserveRegistrationTableViewCell.id, bundle: nil), forCellReuseIdentifier: ReserveRegistrationTableViewCell.id)
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
//        ///////////
//
//        guard let scaledImage = image.scaledToSafeUploadSize,
//            let data = scaledImage.jpegData(compressionQuality: 0.4) else {
//                completion(nil)
//                return
//        }
//
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        
//        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
//        refStorage.child("hyuranociId").child(imageName).putData(data, metadata: metadata) { meta, error in
//            if let error = error {
//                print(error)
//            }
//            
//            self.storage.child("hyuranociId").child(imageName).downloadURL(completion: { (url, error) in
//                if error != nil {
//                    print(error as Any)
//                } else {
//                    guard let imageURL = url?.absoluteURL else { return }
//                    completion(imageURL)
//                }
//                
//            })
//        }

        
        
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
            if topHotelCell == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: TopHotelTableViewCell.id, for: indexPath) as! TopHotelTableViewCell
                topHotelCell = cell
                topHotelCell.parrentViewController = self
            }
            return topHotelCell
        default:
            if topRestaurantCell == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: TopRestaurantTableViewCell.id, for: indexPath) as! TopRestaurantTableViewCell
                topRestaurantCell = cell
                topRestaurantCell.parrentViewController = self
            }
            return topRestaurantCell
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