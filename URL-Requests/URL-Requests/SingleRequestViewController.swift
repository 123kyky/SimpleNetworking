//
//  SingleRequestViewController.swift
//  URL-Requests
//
//  Created by Kyle Roberts on 2/22/16.
//  Copyright © 2016 com.floundertech. All rights reserved.
//

import UIKit

class SingleRequestViewController: UIViewController {
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outputLabel.text = "Request not started."
    }

    @IBAction func requestButtonTapped(sender: AnyObject) {
        outputLabel.text = "Request started."
        sendRequest()
    }
    
    func sendRequest() {
        let url = NSURL(string: "https://twotter.com/search?q=%40twitterapi")
        let request = NSURLRequest(URL: url!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if error == nil {
                    self.outputLabel.text = "Request completed."
                    print("Successful response: \(response)")
                    print("Successful response data: \(data)")
                } else {
                    self.outputLabel.text = "Request failed."
                    print("Request failed: \(error)")
                }
            })
                   
        })
        
        task.resume()
    }
}
