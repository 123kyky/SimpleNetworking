//
//  MultipleRequestViewController.swift
//  URL-Requests
//
//  Created by Kyle Roberts on 3/2/16.
//  Copyright © 2016 com.floundertech. All rights reserved.
//

import UIKit

class MultipleRequestViewController: UIViewController {
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var outputLabel: UILabel!

    @IBAction func requestButtonTapped(sender: AnyObject) {
        let url = NSURL(string: "https://api.twitter.com/oauth2/token")
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("Base " + self.consumerKey(), forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSData(base64EncodedString: "grant_type=client_credentials", options: .IgnoreUnknownCharacters)
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
    
    func consumerKey() -> String {
        let consumerKey = "FmvyKuNsVaxTLog8wHTAIfn5y"
        let secret = "vjfkanLAQ7ojpIE5k7iEAsfLAoMVSRTOQnahMbF7Iw42t1zZoZ"
        let string = consumerKey + ":" + secret
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
        
        return data!.base64EncodedStringWithOptions([])
    }
}
