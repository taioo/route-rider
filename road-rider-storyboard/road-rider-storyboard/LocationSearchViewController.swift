//
//  LocationSearchViewController.swift
//  RouteRider
//
//  Created by Thaer Aldefai on 14.12.20.
//  Copyright © 2020 Thaer Aldefai. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate  {
    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    // map variables
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    var searchSelection = MKLocalSearchCompletion()
    var mainView: MainViewController? = nil

    var matchedItem = MKMapItem()
    var itemName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        textFieldOutlet.addTarget(self, action: #selector(textFieldEditingDidChange), for: UIControl.Event.editingChanged)
        
        // Set the delegate for the Completer
        searchCompleter.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        // Configure the cell...
        cell.textLabel?.text = self.searchResults[indexPath.row].title
        cell.detailTextLabel?.text = self.searchResults[indexPath.row].subtitle
        return cell
    }// cellfor row

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        searchSelection = completion
        mainView?.userDidSelect(searchSelection: searchSelection)
        _ = navigationController?.popViewController(animated: true)

        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            print("#################"+String(describing:coordinate))
        }
    }// didSelectRowAt
    
    
    // MARK: - TextField Delegates
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        self.searchResults.removeAll()
        // send the text to the completer
        searchCompleter.queryFragment = self.textFieldOutlet.text!
    }

}

// MapKit methods
extension LocationSearchViewController: MKLocalSearchCompleterDelegate {
   func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
       searchResults = completer.results
       self.tableViewOutlet.reloadData()
   }
}

// Hide keyboard if view is tapped
extension UIViewController
{
    // to call place self.hideKeyboard() in viewdidload
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
