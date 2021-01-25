//
//  ViewController.swift
//  RouteRider
//
//  Created by Thaer Aldefai on 03.01.21.
//  Copyright © 2020 Thaer Aldefai. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class MainViewController: UIViewController {

    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var araivalDate: UIButton!
    
    private var fromDate: Date?
    private var toDate: Date?
    private var lastButton: UIButton?
    private var locationFrom: MKLocalSearchCompletion?
    private var locationTo: MKLocalSearchCompletion?
    private var routesTable: RoutesTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        saveButton.isEnabled = false
        saveButton.alpha = 0.5
        fromDate = fromDatePicker.date
        araivalDate.isEnabled = false
        araivalDate.alpha = 0.5
    }
    
    
    @IBAction func saveRoute(_ sender: UIButton) {
        // save to coredata
        createData();
        
        saveButton.isEnabled = false
        saveButton.alpha = 0.5
        routesTable?.refresh()
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
              fromDate = sender.date
    }
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
      }
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ( segue.destination is LocationSearchViewController)
        {
            lastButton = sender as? UIButton
            (segue.destination as! LocationSearchViewController).mainView = self
    
        }
        
        if ( segue.destination is RoutesTableViewController)
        {
            routesTable = segue.destination as? RoutesTableViewController
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func userDidSelect(searchSelection: MKLocalSearchCompletion) {
        if( lastButton == fromButton ) {
            locationFrom = searchSelection
        } else if(lastButton == toButton){
            locationTo = searchSelection
        }
        
        if( locationFrom != nil && locationTo != nil ) {
            calculateTimeForRoute(from: locationFrom!, to: locationTo!) { (travelTime: Double?, error: Error?) -> Void in
                // save enabled
                //let travelTimeInMin = Int(travelTime!/60)
                self.toDate = self.fromDate?.addingTimeInterval(travelTime!)
                self.saveButton.isEnabled = true
                self.saveButton.alpha = 1
                self.araivalDate.setTitle(self.toDate?.asString(style: .full) , for: .normal)
                self.araivalDate.isEnabled = true
                self.araivalDate.alpha = 1
            }
        }
        
        
        lastButton?.setTitle(searchSelection.title, for: .normal)
    }
    
    private func getCordinates(location:MKLocalSearchCompletion, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            completion(coordinate,error)
        }
    }
    
    private func calculateTimeForRoute(from: MKLocalSearchCompletion,to:MKLocalSearchCompletion, completion: @escaping (Double?, Error?) -> Void) {
        
        let request = MKDirections.Request()
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        // MKLocalSearchCompletion
        getCordinates(location: from) { (cordinatesFrom: CLLocationCoordinate2D?, error: Error?) in
            
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: cordinatesFrom!.latitude, longitude: cordinatesFrom!.longitude), addressDictionary: nil))
            
            self.getCordinates(location: to) { (cordinatesTo: CLLocationCoordinate2D?, error: Error?) in
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: cordinatesTo!.latitude, longitude: cordinatesTo!.longitude), addressDictionary: nil))
                let directions = MKDirections(request: request)
                directions.calculate { [unowned self] response, error in
                    guard let unwrappedResponse = response else { return }

                    let travelTime = unwrappedResponse.routes[0].expectedTravelTime
                    completion(travelTime,error)

                    //self.AraivalDate.text = String(Int(travelTime/60))
                    //print(Int(travelTime/60))
                }
            }
        }
    }
}

extension Date {
  func asString(style: DateFormatter.Style) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = style
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: self)
  }
}



// MARK: - Core Data func
extension MainViewController{
    
    
       func createData(){
           
           //container is set up in the AppDelegates so we need to refer that container.
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           
           //create a context from this container
           let managedContext = appDelegate.persistentContainer.viewContext
           
           //connect to entity.
           let RouteEntity = NSEntityDescription.entity(forEntityName: "RouteEntity", in: managedContext)!
           
               let route = NSManagedObject(entity: RouteEntity, insertInto: managedContext)
               route.setValue(fromDate, forKeyPath: "dateFrom")
               route.setValue(toDate, forKeyPath: "dateTo")
               route.setValue(locationFrom?.title, forKeyPath: "from")
               route.setValue(locationTo?.title, forKeyPath: "to")
    

           
           
           //save inside the Core Data
           do {
               try managedContext.save()
           } catch let error as NSError {
               print("Could not save. \(error), \(error.userInfo)")
           }
       }
    
}
