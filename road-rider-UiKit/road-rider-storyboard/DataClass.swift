//
//  DataClass.swift
//  RouteRider
//
//  Created by Thaer on 12.02.21.
//

import Foundation
import CoreData
import UIKit

class DataClass: DataProtocol{

   
     var myData: [RouteEntity] = []
    

    init() {
        myData = retrieveData()
     }
    
    internal func retrieveData() -> [RouteEntity] {
        
        //refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        //create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RouteEntity")
        

        do {
            let result = try managedContext.fetch(fetchRequest)
            return result as? [RouteEntity] ?? []
            
        } catch {
            
            print("Failed")
            return []
        }
    }
    
    
    
    func createData(   fromDate: Date?, toDate: Date? , locationFrom: String? , locationTo: String?){
        
        //container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //connect to entity.
        let RouteEntity = NSEntityDescription.entity(forEntityName: "RouteEntity", in: managedContext)!
        
        let route = NSManagedObject(entity: RouteEntity, insertInto: managedContext)
        route.setValue(fromDate, forKeyPath: "dateFrom")
        route.setValue(toDate, forKeyPath: "dateTo")
        route.setValue(locationFrom, forKeyPath: "from")
        route.setValue(locationTo, forKeyPath: "to")
    

        //save inside the Core Data
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    
}
