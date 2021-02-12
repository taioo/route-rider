//
//  DataProtocol.swift
//  RouteRider
//
//  Created by Thaer Aldefai on 30.01.21.
//  Copyright © 2020 Thaer Aldefai. All rights reserved.
//

import Foundation

protocol DataProtocol {
    var myData: [RouteEntity] { get }
    func createData(fromDate: Date?, toDate: Date? , locationFrom: String? , locationTo: String?)
}

