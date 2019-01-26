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
//        if let result = UIApplication.appDelegate.dataManager.fetchAllEventsFromNowTill(date: Date(), for: Category(context: NSManagedObjectContext())) {
//            events = result
//        } else {
//            let alert = UIAlertController(title: "OOPS", message: "No found events try again", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
//            present(alert, animated: true)
//        }
        title = "Events"
        // Do any additional setup after loading the view.
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
