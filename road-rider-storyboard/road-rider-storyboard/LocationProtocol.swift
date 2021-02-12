//
//  MapProtocol.swift
//  RouteRider
//
//  Created by Thaer Aldefai on 12.02.21.
//

import Foundation

protocol LocationProtocol{
    var searchResults: [Location] { get }
    var locationFrom: Location? { get }
    var locationTo: Location? { get }
    
    func setQueryFragment(text: String)
    func saveLocationFrom(index: Int)
    func saveLocationTo(index: Int)
    func setDelegate(delegateObject: Any)
    func calculateTimeForRoute(completion: @escaping (Double?, Error?) -> Void)
}
