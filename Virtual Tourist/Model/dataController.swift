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
    

    func saveAlbum(parameters:[String: AnyObject]){
            if !parameters.isEmpty{
                        let album = Albums(context: managedContext)
                        for (key, value) in parameters {
                            album.setValue(value, forKey: "\(key)")
                    }
                        appDelegate.saveContext()
            }
    }
    
    
    func savePhoto(parameters: Photos) {
        managedContext.insert(parameters)
        appDelegate.saveContext()
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
    
    func deleteFrom(entityName: String, fetchFormat: NSPredicate) -> Bool{
       let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = fetchFormat
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        let result = try? managedContext.execute(request)
        
        if let _ = result {
            return true
        } else {
            return false
            }
        }
    
    
}

