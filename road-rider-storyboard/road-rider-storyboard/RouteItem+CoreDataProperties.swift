//
//  RouteItem+CoreDataProperties.swift
//  RouteRider
//
//  Created by Thaer Aldefai on 02.01.21.
//  Copyright © 2020 Thaer Aldefai. All rights reserved.
//
//

import Foundation
import CoreData


extension RouteItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RouteItem> {
        return NSFetchRequest<RouteItem>(entityName: "RouteEntity")
    }

    @NSManaged public var dateFrom: Date?
    @NSManaged public var dateTo: Date?
    @NSManaged public var from: String?
    @NSManaged public var to: String?

}
