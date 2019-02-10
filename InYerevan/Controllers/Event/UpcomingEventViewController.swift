//
//  Upco
//  UpcomingEventViewController.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/16/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import SDWebImage

class UpcomingEventViewController: UIViewController {
    static let id = "UpcomingEventViewController"
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category!
    private var timeGroup = ["Today", "This Week", "This Month", "All Events"]
    private var todayEvents = [Event]()
    private var thisWeekEvents = [Event]()
    private var thisMonthEvents = [Event]()
    private var allEvents = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todayEvents = UIApplication.dataManager.fetchAllEventsFromNowTill(date: Date().endOfDay, for: category)
        thisWeekEvents = UIApplication.dataManager.fetchAllEventsFromNowTill(date: Date().endOfWeek, for: category)
        thisMonthEvents = UIApplication.dataManager.fetchAllEventsFromNowTill(date: Date().endOfMonth, for: category)
        allEvents = UIApplication.dataManager.fetchAllEventsFromNowTill(date: Date().duringOneYear, for: category)
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        title = "Upcoming Events"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

extension UpcomingEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.bounds.height / 3
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.id, for: indexPath) as! UpcomingTableViewCell
        var firstEvent: Event!
        cell.prepareCellWith(label: timeGroup[indexPath.row], background: #imageLiteral(resourceName: "Cinema"))
        var randomIndex = 0 
        switch indexPath.row {
        case 0: 
            if todayEvents.count > 0 {
                randomIndex = Int.random(in: 0..<todayEvents.count)
                firstEvent = todayEvents[randomIndex]
            }
        case 1: 
            if thisWeekEvents.count > 0 {
                randomIndex = Int.random(in: 0..<thisWeekEvents.count)
                firstEvent = thisWeekEvents[randomIndex]
            }
        case 2:  
            if thisMonthEvents.count > 0 {
                randomIndex = Int.random(in: 0..<thisMonthEvents.count)
                firstEvent = thisMonthEvents[randomIndex]
            }
        default: 
            if allEvents.count > 0 {

                randomIndex = Int.random(in: 0..<allEvents.count)
                firstEvent = allEvents[randomIndex]
            }
        }
        
        if let images = firstEvent?.images?.allObjects as? [Picture] {
            if images.count > 0 {
                let randomNumber = Int.random(in: 0..<images.count) 
                cell.backgroundImageView.sd_setImage(with: URL.init(string: images[randomNumber].url!))
            } 
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeGroup.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        func goToEventsVCWith(events: [Event]) {
            let vc = storyboard?.instantiateViewController(withIdentifier: EventsViewController.id) as! EventsViewController
            vc.events = events
            navigationController?.pushViewController(vc, animated: true)
        }
        
        switch indexPath.row {
        case 0 : 
            goToEventsVCWith(events: todayEvents)
        case 1:
            goToEventsVCWith(events: thisWeekEvents)
        case 2: 
            goToEventsVCWith(events: thisMonthEvents)
        default: 
            goToEventsVCWith(events: allEvents)
        }
    
    }
}
