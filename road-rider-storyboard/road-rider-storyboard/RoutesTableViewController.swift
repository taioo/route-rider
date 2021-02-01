//
//  RoutesTableViewController.swift
//  RouteRider
//
//  Created by Thaer Aldefai on 03.01.21.
//  Copyright © 2020 Thaer Aldefai. All rights reserved.
//

import UIKit
import CoreData

class RoutesTableViewController: UITableViewController  {

    private var myData: [RouteEntity] = []
    
    
    @IBOutlet var routesTabeleView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        routesTabeleView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func refresh (){
        self.myData = DataClass().myData
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteItem", for: indexPath)
        (cell.viewWithTag(1) as? UILabel)?.text = myData[indexPath.item].from
        (cell.viewWithTag(2) as? UILabel)?.text = myData[indexPath.item].to
        (cell.viewWithTag(3) as? UILabel)?.text = myData[indexPath.item].dateFrom?.asString(style: .short)
        (cell.viewWithTag(4) as? UILabel)?.text = myData[indexPath.item].dateTo?.asString(style: .short)
        return cell
    }
}
