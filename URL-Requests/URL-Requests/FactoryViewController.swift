//
//  FactoryViewController.swift
//  URL-Requests
//
//  Created by Kyle Roberts on 3/20/16.
//  Copyright © 2016 com.floundertech. All rights reserved.
//

import UIKit

class FactoryViewController: UIViewController {
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    
    var authToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.outputLabel.text = "Waiting..."
    }
    
    @IBAction func requestButtonTapped(sender: AnyObject) {
        self.outputLabel.text = "Request started."
        self.getAtTwitterAPI()
    }
    
    func getAtTwitterAPI() {
        let manager = SimpleNetworkingManager()
        manager.success = { (json) -> Void in
            self.outputLabel.text = "Request successful."
        }
        manager.failure = { (error) -> Void in
            self.outputLabel.text = "Request errored."
        }
        manager.getAtTwitterAccount("twitterAPI")
    }
}
