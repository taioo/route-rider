//
//  ViewController.swift
//  road-rider-storyboard
//
//  Created by Thaer Aldefai on 27.10.20.
//

import UIKit
import MapKit


class ViewController: UIViewController {

    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var routesTable: UITableView!
    
    
    var searchSelection = MKLocalSearchCompletion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ( segue.destination is LocationSearchViewController)
        {
            if( (sender as? UIButton) == fromButton ) {
                
            }
            (segue.destination as! LocationSearchViewController).mainView = self
            print("sdfghsgdfh")
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func userDidSelect(searchSelection: MKLocalSearchCompletion) {
        fromButton.setTitle(searchSelection.title, for: UIControl.State.normal)
    }
}

