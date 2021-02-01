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

    var myMapSearch = MyMapClass()

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
        DataClass().createData(fromDate: fromDate, toDate: toDate, locationFrom: myMapSearch.getTitelLocationFrom(), locationTo: myMapSearch.getTitelLocationTo());
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
    
    func userDidSelect(index : Int) {
        if( lastButton == fromButton ) {
            myMapSearch.saveLocationFrom(index: index)
            lastButton?.setTitle(myMapSearch.locationFrom?.title, for: .normal)
            myMapSearch.searchResults.removeAll()
        } else if(lastButton == toButton){
            myMapSearch.saveLocationTo(index: index)
            lastButton?.setTitle(myMapSearch.locationTo?.title, for: .normal)
            myMapSearch.searchResults.removeAll()
        }

        if( myMapSearch.locationFrom != nil && myMapSearch.locationTo != nil ) {
            myMapSearch.calculateTimeForRoute() { (travelTime: Double?, error: Error?) -> Void in
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
