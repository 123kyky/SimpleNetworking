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
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController
            controller!.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller!.navigationItem.leftItemsSupplementBackButton = true
            controller!.title = objects[indexPath.row]
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegueWithIdentifier("singleRequest", sender: self)
        case 1:
            self.performSegueWithIdentifier("multipleRequest", sender: self)
        default:
            break
        }
    }

}

