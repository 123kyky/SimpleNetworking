//
//  SimpleNetworkingManager.swift
//  URL-Requests
//
//  Created by Kyle Roberts on 3/20/16.
//  Copyright © 2016 com.floundertech. All rights reserved.
//

import UIKit

class SimpleNetworkingManager {
    private static var authToken: String?
    
    var success: ((NSDictionary?) -> Void)?
    var failure: ((NSError?) -> Void)?
    
    func getAtTwitterAccount(twitter: String) {
        SimpleNetworkingManager.checkAuthentication({ () -> Void in
            let request = self.requestForURL("https://api.twitter.com/1.1/search/tweets.json?q=%40\(twitter)")
            self.runRequest(request)
        })
    }
    
    private static func authenticate(completion: () -> Void) {
        let request = SimpleNetworkingManager.requestForAuthentication()
        let manager = SimpleNetworkingManager()
        manager.success = { (json) -> Void in
            SimpleNetworkingManager.authToken = json!["access_token"] as? String
            completion()
        }
        manager.runRequest(request)
    }
    
    private static func checkAuthentication(completion: () -> Void) {
        if SimpleNetworkingManager.authToken == nil {
            self.authenticate(completion)
        }
    }
    
    // MARK: Requests
    
    private static func requestForAuthentication() -> NSURLRequest {
        let url = NSURL(string: "https://api.twitter.com/oauth2/token")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("SimpleNetworking", forHTTPHeaderField: "User-Agent")
        request.setValue("Basic " + self.consumerKey(), forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "grant_type=client_credentials".dataUsingEncoding(NSUTF8StringEncoding)
        
        return request
    }
    
    private func requestForURL(url: String) -> NSURLRequest {
        let url = NSURL(string: url)
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("Bearer " + SimpleNetworkingManager.authToken!, forHTTPHeaderField: "Authorization")
        
        return request
    }

    private func runRequest(request: NSURLRequest) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                let httpResponse = response as? NSHTTPURLResponse
                if httpResponse?.statusCode == 200 {
                    print("Successful response: \(response)")
                    
                    if let json = self.dictionaryFromJSONData(data!) {
                        self.success?(json)
                    } else {
                        self.failure?(nil)
                    }
                } else if error != nil {
                    self.failure?(error)
                    print("Request failed: \(error)")
                } else {
                    self.failure?(nil)
                    print("Failed response: \(response)")
                }
            })
        })
        
        task.resume()
    }
    
    // MARK: Utils
    
    private static func consumerKey() -> String {
        let consumerKey = "FmvyKuNsVaxTLog8wHTAIfn5y"
        let secret = "vjfkanLAQ7ojpIE5k7iEAsfLAoMVSRTOQnahMbF7Iw42t1zZoZ"
        let string = consumerKey + ":" + secret
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
        return data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
    
    private func dictionaryFromJSONData(data: NSData) -> NSDictionary? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            print("Successful response data: \(json)")
            
            return json as? NSDictionary
        } catch {
            print("Error: Unexpected data on successful response.")
            return nil
        }
    }
}
