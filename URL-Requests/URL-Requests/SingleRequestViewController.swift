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
        
        self.outputLabel.text = "Waiting..."
    }

    @IBAction func requestButtonTapped(sender: AnyObject) {
        self.outputLabel.text = "Request started."
        self.sendRequest()
    }
    
    func sendRequest() {
        let url = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json?q=%40twitterapi")
        let request = NSURLRequest(URL: url!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if error == nil {
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
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
