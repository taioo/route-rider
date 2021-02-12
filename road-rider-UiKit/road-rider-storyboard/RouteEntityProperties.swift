//
//  RouteEntity+CoreDataProperties.swift
//  RouteRider
//
//  Created by Thaer on 23.01.21.
//  Copyright © 2020 Thaer Aldefai. All rights reserved.
//
//

import Foundation
import CoreData


extension RouteEntity {
    

    @NSManaged public var dateFrom: Date?
    @NSManaged public var dateTo: Date?
    @NSManaged public var from: String?
    @NSManaged public var to: String?
    

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RouteEntity> {
        return NSFetchRequest<RouteEntity>(entityName: "RouteEntity")
    }

}
