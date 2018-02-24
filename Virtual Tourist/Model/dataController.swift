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
    
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var managedContext: NSManagedObjectContext = NSManagedObjectContext()
        var managedObject: NSManagedObject?
    
     init(){
        managedContext = (appDelegate?.persistentContainer.viewContext)!
    }
    
    func getEntity(entityNamae: String) {
        let entity = NSEntityDescription.entity(forEntityName: entityNamae, in: managedContext)
        managedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
    }
    
    
    func save(parameters:[String: AnyObject]?, parameterAsArray: [[String:AnyObject]]?){
        if parameters != nil {
            if !parameters!.isEmpty{
                for (key, value) in parameters! {
                    managedObject?.setValue(value, forKey: "\(key)")
                }
            }
            
            do {
                try  managedContext.save()
            }catch{
                fatalError("Couldn't save :( ")
            }
        }
        
        if parameterAsArray != nil {
            if !parameterAsArray!.isEmpty {
                for values in parameterAsArray! {
                    for (key, value) in values {
                        managedObject?.setValue(value, forKey: "\(key)")
                    }
                }
            }
            do {
                try  managedContext.save()
                print("SAVED :D ")
            }catch{
                fatalError("Couldn't save :( ")
            }
            
        }
    }
    
    
    
    func fetchFrom(entityName: String, predicate: String?) -> [NSManagedObject]{
        var data = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if predicate != nil {
            let newPredicate = NSPredicate(format: "albumId = %@", argumentArray: [predicate!])
            fetchRequest.predicate = newPredicate
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

