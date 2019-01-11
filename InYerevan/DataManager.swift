//
//  DataManager.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/16/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase
import Firebase
import FirebaseFirestore

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
    func saveEvent(title: String, date: Date, category: String, pictures: [UIImage], details: String, coordinates: (lat: Double, long: Double)) {
        let context = persistentController.newBackgroundContext 
        let event = Event(context: context)
        event.title = title
        event.date = date
        event.details = details
        let location = Coordinates(context: context)
        location.latitude = coordinates.lat
        location.longitude = coordinates.long
        event.category = requestCategoryWith(name: category, in: context)
        persistentController.saveContext(context)
        persistentController.viewContext.refreshAllObjects()
    }
    
    func fetchAllEventsFromNowTill(date: Date, for category: Category) -> [Event]? {
        let context = persistentController.viewContext 
        let request: NSFetchRequest<Event> =  Event.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = NSPredicate(format: "date > %@", NSDate())
        
        return (try? context.fetch(request))
    }
    
    func fetchCategories() -> [Category]? {
        let context = persistentController.viewContext 
        let request: NSFetchRequest<Category> =  Category.fetchRequest()
        return (try? context.fetch(request))
    }
    
    //Private Interface
    //  Write only functions which will support your public functions 
    
    private func requestCategoryWith(name: String, in context: NSManagedObjectContext ) -> Category {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        if let objects = (try? context.fetch(request)) {
            if let category = objects.first {
                return category
            } 
        }
        let category = Category(context: context)
        category.name = name 
        return category
        
    }
    
    
}
