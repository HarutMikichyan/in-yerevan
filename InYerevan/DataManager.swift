//
//  DataManager.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/16/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    private let persistentController: PersistentController
    
    init(_ persistentController: PersistentController) {
        self.persistentController = persistentController
    }
    
    //Public Interface
    //  Write only public functions 
    
    func saveViewContext() {
        persistentController.saveViewContext()
    }
    
    // MARK: - Event
    func saveEvent(title: String, date: Date, cover: UIImage, pictures: [UIImage], details: String, coordinates: (lat: Double, long: Double)) {
        let context = persistentController.newBackgroundContext 
        let event = Event(context: context)
        event.title = title
        event.date = date
        event.details = details
        let location = Coordinates(context: context)
        location.latitude = coordinates.lat
        location.longitude = coordinates.long
        persistentController.saveContext(context)
        persistentController.viewContext.refreshAllObjects()
    }
    
    func fetchAllEvents() -> [Event]? {
        let context = persistentController.viewContext 
        let request: NSFetchRequest<Event> =  Event.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = NSPredicate(format: "date > %@", NSDate())
        let objects = (try? context.fetch(request))
        return objects
    }
    
 
    //Private Interface
    //  Write only functions which will support your public functions 
    
    
    
    
    
}
