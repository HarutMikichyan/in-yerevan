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
    private let collectionReference = Firestore.firestore().collection("Events")
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
        var urls = [String]()
        for index in 0..<pictures.count {
            saveEventImages(pictures[index], index: index, title: title) { (url) in
                
                guard let url = url else {return}
                urls.append(url)
                if index == pictures.count - 1 {
                    let _ = self.collectionReference.whereField("date", isEqualTo: date).getDocuments { (querySnapshot, error) in
                        if error == nil {
                            for document in querySnapshot!.documents {
                                self.collectionReference.document(document.documentID).setData(["pictureURLs": urls], merge: true)
                            }
                            self.fetchEventsFromServerSide()
                        }
                    }
                    
                }
                
            }
        }
        
        let fireBaseEvent = FirebaseEvent(date: date, details: details, pictureURLs: urls, title: title, company: User.email, visitorsCount: 0, latitude: coordinates.lat, longitude: coordinates.long, category: category)
        saveEventsInServer(event: fireBaseEvent)
        
        
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
        let _ = collectionReference.whereField("date", isGreaterThan: Date()).getDocuments { (querySnapshot, error) in
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
    
    func downloadImage(at url: URL, in event: Event, completion: @escaping (UIImage?) -> Void) {
        let storageReferance = Storage.storage().reference().child("event/\(User.email)")
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: imageData))
        }
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
        collectionReference.addDocument(data: event.representation) { error in
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
        let currentCategory = requestCategoryWith(name: category, in: context)
        event.category = currentCategory
        currentCategory.events?.adding(event)
        event.organizer = requestOrganizerWith(name: company, in: context)
        var newPictures = [Picture]()
        
        for url in pictureURLs {
            let picture = Picture(context: context)
            picture.url = url
            newPictures.append(picture)
        }
        event.images = NSSet.init(array: newPictures)
        persistentController.saveContext(context)
        persistentController.viewContext.refreshAllObjects()
    }
    
    private func saveEventImages(_ images: UIImage, index: Int, title: String, completion: @escaping (String?) -> Void ) {
        let storageReferance = Storage.storage().reference().child("event/\(User.email)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        guard let scaledImage = images.scaledToSafeUploadSize,
            let data = scaledImage.jpegData(compressionQuality: 0.4) else {
                completion(nil)
                return
        }
        
        storageReferance.child(title).child("\(index)").putData(data, metadata: metadata) { (metadata, error) in
            if let error = error {
                print(error)
            }
            
            storageReferance.child(title).child("\(index)").downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error as Any)
                } else {
                    guard let downloadURL = url?.absoluteString else {
                        return
                    }
                    DispatchQueue.main.async {
                        completion(downloadURL)
                    }
                }
            })
        }
    }
    
    private func eraseLocalCache() {
        let context = persistentController.newBackgroundContext
        let requestForEvent = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        let requestForPicture = NSFetchRequest<NSFetchRequestResult>(entityName: "Picture")
        let requestForCoordinate = NSFetchRequest<NSFetchRequestResult>(entityName: "Coordinates")
        let requestForCompany = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        let requestCategory = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        let deleteRequestForEvent = NSBatchDeleteRequest(fetchRequest: requestForEvent)
        let deleteRequestForPicture = NSBatchDeleteRequest(fetchRequest: requestForPicture)
        let deleteRequestForCoordinate = NSBatchDeleteRequest(fetchRequest: requestForCoordinate)
        let deleteRequestForCompany = NSBatchDeleteRequest(fetchRequest: requestForCompany)
        let deleteRequestForCategory = NSBatchDeleteRequest(fetchRequest: requestCategory)
        
        do {
         //   try context.execute(deleteRequestForCategory)
            try context.execute(deleteRequestForEvent)
            try context.execute(deleteRequestForPicture)
            try context.execute(deleteRequestForCoordinate)
            try context.execute(deleteRequestForCompany)
        } catch  {
            print("Error while erasing data DataManager row 134")
        }
    }
    
    
}
