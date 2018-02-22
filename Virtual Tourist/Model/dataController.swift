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
    
    
    func save(parameters:[String: AnyObject]){
        if !parameters.isEmpty{
            for (key, value) in parameters {
                managedObject?.setValue(value, forKey: "\(key)")
            }
        }
        
        do {
            try  managedContext.save()
        }catch{
            fatalError("Couldn't save :( ")
        }
    }
    
    func fetchFrom(entityName: String) -> [NSManagedObject]{
        var data = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        do{
         data = try managedContext.fetch(fetchRequest)
        }catch{
            fatalError("Couldn't Fetch ")
        }
        return data
    }
    
    func deleteFrom(entityName: String, fetchFormat: String) {
       let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate.init(format: fetchFormat)
        if let results = try? managedContext.fetch(fetchRequest){
            for object in results {
                managedContext.delete(object)
            }
        }
    }
    
}

