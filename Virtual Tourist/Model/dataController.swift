//
//  dataController.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/22/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataController {
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var managedContext: NSManagedObjectContext = NSManagedObjectContext()
        var managedObject: NSManagedObject?
    
     init(){
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func getEntity(entityNamae: String) {

        let entity = NSEntityDescription.entity(forEntityName: entityNamae, in: managedContext)
        managedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
    }
    

    func save(parameters:[String: AnyObject]){
            if !parameters.isEmpty{
                if let _ = parameters["albumId"] {
                    let album = Albums(context: managedContext)
                    for (key, value) in parameters {
                        album.setValue(value, forKey: "\(key)")
                    }

                     //managedContext.insert(album)

                    appDelegate.saveContext()

                }else {
                    for (key, value) in parameters {
                    if let dataArray = value as? NSArray {

                        for singleItem in dataArray {
                            let photo = Photos(context: managedContext)
                            photo.albumId = Int64(key)!
                            photo.photo = singleItem as? Data
                             managedContext.insert(photo)
                        }

                    }
                    }
                    appDelegate.saveContext()
                }
            }
    }

    
    
    func fetchFrom(entityName: String, predicate: NSPredicate?) -> [NSManagedObject]{
        var data = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        do{
         data = try managedContext.fetch(fetchRequest)
        }catch{
            fatalError("Couldn't Fetch ")
        }
        return data
    }
    
    func deleteFrom(entityName: String, fetchFormat: String) -> Bool{
        print("got the sdelete \(fetchFormat)")
       let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate.init(format: fetchFormat)
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        let result = try? managedContext.execute(request)
        
        if let result = result {
            return true
        } else {
            return false
            }
        }
    
    
    func deleteAll(entityName: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        let result = try? managedContext.execute(request)

        if let result = result {
            print("OK \(result)")
        }else{
            
            print("Nope")
        }

        
    }
    
}

