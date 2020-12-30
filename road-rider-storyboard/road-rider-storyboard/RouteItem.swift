//
//  RouteItem.swift
//  RouteRider
//
//  Created by Thaer Aldefai on 28.12.20.
//  Copyright © 2020 Thaer Aldefai. All rights reserved.
//

import Foundation
import CoreData

public class RouteItem: NSManagedObject, Identifiable{
    
    
    @NSManaged var StartDate: Date?
    @NSManaged var from: String?
    @NSManaged var to: String?
    
    static func getAllItem() -> NSFetchRequest<RouteItem>{
        let request: NSFetchRequest<RouteItem> = RouteItem.fetchRequest() as! NSFetchRequest<RouteItem>
        let sortDesscrioptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors=[sortDesscrioptor]
        return request
    }
    
    
    
}
