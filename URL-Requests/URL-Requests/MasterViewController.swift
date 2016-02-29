//
//  MasterViewController.swift
//  URL-Requests
//
//  Created by Kyle Roberts on 2/22/16.
//  Copyright © 2016 com.floundertech. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var objects = ["Single Request", "Multiple Requests", "Handling a Response", "Handling a Failure"]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                var viewController: UIViewController?
                
                switch (indexPath.row) {
                case 0:
                    viewController = SingleRequestViewController()
                case 1:
                    viewController = SingleRequestViewController()
                case 2:
                    viewController = SingleRequestViewController()
                case 3:
                    viewController = SingleRequestViewController()
                default:
                    assert(viewController != nil, "View Controller was not set")
                }
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController
                controller!.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller!.navigationItem.leftItemsSupplementBackButton = true
                controller!.title = objects[indexPath.row]
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = objects[indexPath.row]
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

}

