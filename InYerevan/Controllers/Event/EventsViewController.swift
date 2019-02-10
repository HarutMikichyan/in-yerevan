//
//  EventsViewController.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/16/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {
    static let id = "EventsViewController"
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        title = "Events"
    }
    
    
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.id, for: indexPath) as! EventTableViewCell
        cell.prepareCellWith(title: events[indexPath.row].title!,
                             background: #imageLiteral(resourceName: "Technology") ,
                             date: events[indexPath.row].date!)
        
        if let images = events[indexPath.row].images?.allObjects as? [Picture] {
            if let imageURL =  images.first?.url {
                UIApplication.dataManager.downloadImage(at: URL.init(string: imageURL)!, in: events[indexPath.row]) { (image) in
                    if let image = image {
                        cell.prepareCellWith(title: self.events[indexPath.row].title!,
                                             background: image ,
                                             date: self.events[indexPath.row].date!)
                    } 
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: EventViewController.id) as! EventViewController
        vc.event = events[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
