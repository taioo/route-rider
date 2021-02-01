//
//  LocationManage.swift
//  RouteRider
//
//  Created by Thaer Aldefai on 30.01.21.
//  Copyright © 2020 Thaer Aldefai. All rights reserved.
//

import Foundation
import MapKit

protocol MyMapProtocol{
    var searchResults: [MKLocalSearchCompletion] { get set }
    var searchCompleter: MKLocalSearchCompleter { get set }
    var locationFrom: MKLocalSearchCompletion? { get set }
    var locationTo: MKLocalSearchCompletion? { get set }
    
    func getTitelAtIndex (index: Int) -> String
    func getsubtitelAtIndex (index: Int) -> String
    func saveLocationFrom(index: Int)
    func saveLocationTo(index: Int)
    func getTitelLocationFrom()-> String
    func getTitelLocationTo()-> String
    func calculateTimeForRoute(completion: @escaping (Double?, Error?) -> Void)
}

class MyMapClass: MyMapProtocol{
    
    var searchResults = [MKLocalSearchCompletion]()
    var searchCompleter = MKLocalSearchCompleter()
    var locationFrom: MKLocalSearchCompletion?
    var locationTo: MKLocalSearchCompletion?
    private var matchedItem = MKMapItem()
    
    

    func getTitelAtIndex (index: Int) -> String{
        return searchResults[index].title
    }
    
    func getsubtitelAtIndex (index: Int) -> String{
        return searchResults[index].subtitle
    }
    
    
    func saveLocationFrom(index: Int){
        locationFrom = searchResults[index]
    }
    
    func saveLocationTo(index: Int){
        locationTo = searchResults[index]
    }
    
    
    func getTitelLocationFrom()-> String{
        return locationFrom!.title
    }
    
    func getTitelLocationTo()-> String{
        return locationTo!.title
    }
    
    
    func calculateTimeForRoute(completion: @escaping (Double?, Error?) -> Void) {
        
        let request = MKDirections.Request()
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        // MKLocalSearchCompletion
        getCordinates(location: locationFrom) { (cordinatesFrom: CLLocationCoordinate2D?, error: Error?) in
            
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: cordinatesFrom!.latitude, longitude: cordinatesFrom!.longitude), addressDictionary: nil))
            
            self.getCordinates(location: self.locationTo) { (cordinatesTo: CLLocationCoordinate2D?, error: Error?) in
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
    mainView!.myMapSearch.searchResults = completer.results
       self.tableViewOutlet.reloadData()
   }
}
