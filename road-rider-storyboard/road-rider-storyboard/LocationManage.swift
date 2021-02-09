//
//  LocationManage.swift
//  RouteRider
//
//  Created by Thaer Aldefai on 30.01.21.
//  Copyright © 2020 Thaer Aldefai. All rights reserved.
//

import Foundation
import MapKit

struct Location {
    var title: String
    var subtitle: String
}


protocol MyMapProtocol{
    var searchResults: [Location] { get }
    var locationFrom: Location? { get }
    var locationTo: Location? { get }
    
    func setQueryFragment(text: String)
    func saveLocationFrom(index: Int)
    func saveLocationTo(index: Int)
    func setDelegate(delegateObject: Any)
    func calculateTimeForRoute(completion: @escaping (Double?, Error?) -> Void)
}

class MyMapClass: MyMapProtocol{
    
    var mkSearchResults: [MKLocalSearchCompletion]
    private var mkSearchCompleter: MKLocalSearchCompleter
    private var mkLocationFrom: MKLocalSearchCompletion?
    private var mkLocationTo: MKLocalSearchCompletion?
    
    var searchResults: [Location]{
        get {
            return mkSearchResults.map { element in
                Location(
                    title: element.title,
                    subtitle: element.subtitle
                )
            }
        }
        
        set{ }
    }
    var locationFrom: Location? {
        get {
            return mkLocationFrom != nil ?
                Location(
                    title: mkLocationFrom!.title,
                    subtitle: mkLocationFrom!.subtitle
                ) : nil;
        }
    }
    var locationTo: Location? {
        get {
            return mkLocationTo != nil ? Location(
                title: mkLocationTo!.title,
                subtitle: mkLocationTo!.subtitle
                ) : nil;
        }
    }
    
    init() {
        mkSearchResults = [MKLocalSearchCompletion]()
        mkSearchCompleter = MKLocalSearchCompleter()
    }
    
    func emptySearchResult(){
        mkSearchResults.removeAll()
        searchResults.removeAll()
    }
    
    func setQueryFragment(text: String){
        emptySearchResult()
        // send the text to the completer
        mkSearchCompleter.queryFragment = text
    }
    
    
    func saveLocationFrom(index: Int){
        mkLocationFrom = mkSearchResults[index]
    }
    
    func saveLocationTo(index: Int){
        mkLocationTo = mkSearchResults[index]
    }
    
    
    func setDelegate(delegateObject: Any){
        mkSearchCompleter.delegate = (delegateObject as! MKLocalSearchCompleterDelegate)
    }
    
    
    
    func calculateTimeForRoute(completion: @escaping (Double?, Error?) -> Void) {
        
        let request = MKDirections.Request()
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        // MKLocalSearchCompletion
        getCordinates(location: mkLocationFrom) { (cordinatesFrom: CLLocationCoordinate2D?, error: Error?) in
            
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: cordinatesFrom!.latitude, longitude: cordinatesFrom!.longitude), addressDictionary: nil))
            
            self.getCordinates(location: self.mkLocationTo) { (cordinatesTo: CLLocationCoordinate2D?, error: Error?) in
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: cordinatesTo!.latitude, longitude: cordinatesTo!.longitude), addressDictionary: nil))
                let directions = MKDirections(request: request)
                directions.calculate {response, error in
                    guard let unwrappedResponse = response else { return }
                    
                    let travelTime = unwrappedResponse.routes[0].expectedTravelTime
                    completion(travelTime,error)
                    
                    //self.AraivalDate.text = String(Int(travelTime/60))
                    //print(Int(travelTime/60))
                }
            }
        }
    }
    
    
    private func getCordinates(location:MKLocalSearchCompletion?, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: location!)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            completion(coordinate,error)
        }
    }
}

// MapKit methods
extension LocationSearchViewController: MKLocalSearchCompleterDelegate, MKMapViewDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        mainView!.myMapSearch.mkSearchResults = completer.results
        self.tableViewOutlet.reloadData()
    }
}
