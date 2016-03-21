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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.outputLabel.text = "Waiting..."
    }

    @IBAction func requestButtonTapped(sender: AnyObject) {
        self.outputLabel.text = "Request started."
        self.requestAuthToken()
    }
    
    func requestAuthToken() {
        let url = NSURL(string: "https://api.twitter.com/oauth2/token")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("URL-Requests v1", forHTTPHeaderField: "User-Agent")
        request.setValue("Basic " + self.consumerKey(), forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "grant_type=client_credentials".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                let httpResponse = response as? NSHTTPURLResponse
                if httpResponse?.statusCode == 200 {
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    self.outputLabel.text = "Request completed."
                    print("Successful response: \(response)")
                    print("Successful response data: \(data)")
                    
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        self.getAtTwitterAPI(json["access_token"] as! String)
                    } catch {
                        print("Error: Unexpected data on successful response.")
                    }
                } else if error != nil {
                    self.outputLabel.text = "Request errored."
                    print("Request failed: \(error)")
                } else {
                    self.outputLabel.text = "Request failed."
                    print("Failed response: \(response)")
                    print("Failed response data: \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
                }
            })
        })
        
        task.resume()
    }
    
    func getAtTwitterAPI(token: String) {
        let url = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json?q=%40twitterapi")
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                let httpResponse = response as? NSHTTPURLResponse
                if httpResponse?.statusCode == 200 {
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    self.outputLabel.text = "Request completed."
                    print("Successful response: \(response)")
                    print("Successful response data: \(data)")
                    
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        print("Successful response data: \(json)")
                    } catch {
                        print("Error: Unexpected data on successful response.")
                    }
                } else if error != nil {
                    self.outputLabel.text = "Request errored."
                    print("Request failed: \(error)")
                } else {
                    self.outputLabel.text = "Request failed."
                    print("Failed response: \(response)")
                    print("Failed response data: \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
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
        return data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
}
