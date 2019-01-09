//
//  HotelsViewController.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/20/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class HotelsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hotels"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        navigationController?.isNavigationBarHidden = false
    }
}

extension HotelsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HotelDescriptionViewControllerID")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HotelTableViewCell.id, for: indexPath) as! HotelTableViewCell
        return cell
    }
}
