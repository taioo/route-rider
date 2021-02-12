//
//  LocationSearchViewController.swift
//  RouteRider
//
//  Created by Thaer on 14.12.20.
//  Copyright © 2020 Thaer Aldefai. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate  {
    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var mainView: MainViewController? = nil
    
    override func viewDidLoad() {
        self.hideKeyboard()
        textFieldOutlet.addTarget(self, action: #selector(textFieldEditingDidChange), for: UIControl.Event.editingChanged)
        
        // Set the delegate for the Completer
        mainView!.myMapSearch.setDelegate(delegateObject: self)
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
        return mainView!.myMapSearch.searchResults.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        // Configure the cell...
        cell.textLabel?.text = mainView!.myMapSearch.searchResults[indexPath.row].title
        cell.detailTextLabel?.text = mainView!.myMapSearch.searchResults[indexPath.row].subtitle
        return cell
    }// cellfor row
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        mainView?.userDidSelect(index: indexPath.row)
        navigationController?.popViewController(animated: true)
    }// didSelectRowAt
    
    
    // MARK: - TextField Delegates
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        mainView!.myMapSearch.setQueryFragment(text: self.textFieldOutlet.text!)
    }
}

// Hide keyboard if view is tapped
extension UIViewController{
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
