//
//  DataManager.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/16/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import CoreData
import Firebase
//import FirebaseFirestore

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
        
        saveEventImages(pictures, title: title) { (urls) in
            guard let urls = urls else {return}
            let fireBaseEvent = FirebaseEvent(date: date, details: details, pictureURLs: urls, title: title, company: User.email, visitorsCount: 0, latitude: coordinates.lat, longitude: coordinates.long, category: category)
            saveEventsInServer(event: fireBaseEvent)
            fetchEventsFromServerSide()
        }
        
    }
    
    func fetchAllEventsFromNowTill(date: Date, for category: Category) -> [Event] {
        let context = persistentController.viewContext 
        let request: NSFetchRequest<Event> =  Event.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let predicateSince = NSPredicate(format: "date > %@", NSDate())
        let predicateTill = NSPredicate(format: "date < %@", date as NSDate)
        let predicateCategory = NSPredicate(format: "category = %@", category)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateSince, predicateTill, predicateCategory])
        request.predicate = predicate
        if let events = (try? context.fetch(request)) {
            return events
        }
        
        return []
    }
    
    func fetchCategories() -> [Category]? {
        let context = persistentController.viewContext 
        let request: NSFetchRequest<Category> =  Category.fetchRequest()
        return (try? context.fetch(request))
    }
    
    func fetchEventsFromServerSide() {
        let _ = Firestore.firestore().collection("Events").whereField("date", isGreaterThan: Date()).getDocuments { (querySnapshot, error) in
            if error == nil {
                self.eraseLocalCache()
                for document in querySnapshot!.documents {
                    self.saveEventLocally(from: document)
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
    }
    
    func newCategoryWith(name:String, completion: (Category) -> Void) {
        let context = persistentController.viewContext 
        let category = requestCategoryWith(name: name, in: context)
        completion(category)
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
        persistentController.saveContext(context)
        return category
    }
    
    private func requestOrganizerWith(name: String, in context: NSManagedObjectContext ) -> Company {
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        if let objects = (try? context.fetch(request)) {
            if let category = objects.first {
                return category
            } 
        } 
        let company = Company(context: context)
        company.name = name 
        return company
    }
    
    private func saveEventsInServer(event: FirebaseEvent) {
        let referance = Firestore.firestore().collection("Events")
        referance.addDocument(data: event.representation) { error in 
            if let error = error {
                print(error)
            }
        }
    }
    
    private func saveEventLocally(from data: QueryDocumentSnapshot) {
        guard let date = data["date"] as? Date else { print("date") 
            return}
        guard let details = data["details"] as? String else {print("detai")
            return}
        guard let pictureURLs = data["pictureURLs"] as? [String] else {print("url")
            return}
        guard let title = data["title"] as? String else {print("titl")
            return}
        guard let visitorsCount = data["visitorsCount"] as? Int else {print("Vis") 
            return}
        guard let company = data["company"] as? String  else {print("comp") 
            return}
        guard let latitude = data["latitude"] as? Double else {print("lat") 
            return}
        guard let longitude = data["longitude"] as? Double else {print("long")
            return}
        guard let category = data["category"] as? String else {print("cat")
            return}
        
        let context = persistentController.newBackgroundContext 
        let event = Event(context: context)
        event.title = title
        event.date = date
        event.details = details
        let location = Coordinates(context: context)
        location.latitude = latitude
        location.longitude = longitude
        event.location = location
        event.category = requestCategoryWith(name: category, in: context)
        event.organizer = requestOrganizerWith(name: company, in: context)
        persistentController.saveContext(context)
        persistentController.viewContext.refreshAllObjects()
    }
    
    private func saveEventImages(_ images: [UIImage], title: String, completion: ([String]?) -> Void ) {
        let storageReferance = Storage.storage().reference().child("event/\(User.email)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        var urls = [String]()
        
        for index in 0..<images.count {
            guard let scaledImage = images[index].scaledToSafeUploadSize,
                let data = scaledImage.jpegData(compressionQuality: 0.4) else {
                    completion(nil)
                    return
            }
            storageReferance.child(title).child("\(index)").putData(data, metadata: metadata) { (metadata, error) in
                if error == nil {
                    storageReferance.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            return
                        }
                        urls.append(downloadURL.absoluteString)
                    }
                } else {
                    print(error)
                }   
            }           
        }
        completion(urls)
    }
    
    private func eraseLocalCache() {
        let context = persistentController.newBackgroundContext
        let requestForEvent = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        let requestForPicture = NSFetchRequest<NSFetchRequestResult>(entityName: "Picture")
        let requestForCoordinate = NSFetchRequest<NSFetchRequestResult>(entityName: "Coordinates")
        let requestForCompany = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        
        
        let deleteRequestForEvent = NSBatchDeleteRequest(fetchRequest: requestForEvent)
        let deleteRequestForPicture = NSBatchDeleteRequest(fetchRequest: requestForPicture)
        let deleteRequestForCoordinate = NSBatchDeleteRequest(fetchRequest: requestForCoordinate)
        let deleteRequestForCompany = NSBatchDeleteRequest(fetchRequest: requestForCompany)
        
        do {
            try context.execute(deleteRequestForEvent)
            try context.execute(deleteRequestForPicture)
            try context.execute(deleteRequestForCoordinate)
            try context.execute(deleteRequestForCompany)
        } catch  {
            print("Error while erasing data DataManager row 134")
        }
    }
    
    
}
