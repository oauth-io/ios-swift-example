//
//  ViewController.swift
//  OAuthioSwiftExample
//
//  Created by Antoine Jackson on 31/10/14.
//  Copyright (c) 2014 OAuth.io. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OAuthIODelegate {
    @IBOutlet var login_button: UIButton!
    @IBOutlet var request_button: UIButton!
    @IBOutlet var logout_button: UIButton!
    
    @IBOutlet var name_label: UILabel!
    @IBOutlet var status_label: UILabel!
    
    var oauth_modal: OAuthIOModal? = nil
    var request_object: OAuthIORequest? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.oauth_modal = OAuthIOModal(key: "lP9cZJ_4LiOJmo03x26ZZ1B9iWI", delegate: self)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Click(sender: UIButton) {
        if sender == self.login_button {
            self.status_label.text = "Logging in with Twitter"
            var options = NSMutableDictionary()
            options.setValue("true", forKey: "cache")
            self.oauth_modal?.showWithProvider("twitter", options: options)
        }
        if sender == self.request_button {
            var cache_available = self.oauth_modal?.cacheAvailableForProvider("twitter")
            if cache_available! {
                self.status_label.text = "Getting personal info from Twitter"
                self.name_label.text = "Retrieving..."
                self.request_object?.me(nil, success: { (respDictionary, body, response) -> Void in
                    var dictionary: NSDictionary = respDictionary
                    self.status_label.text = "Successfully got info from Twitter"
                    self.name_label.text = dictionary.objectForKey("name") as? String
                })
            } else {
                self.status_label.text = "Not logged in"
            }
        }
        if sender == self.logout_button {
            var cache_available = self.oauth_modal?.cacheAvailableForProvider("twitter")
            if cache_available! {
                self.oauth_modal?.clearCache()
                self.status_label.text = "Logged out"
            } else {
                self.status_label.text = "Not logged in"
            }

        }
    }
    

    
    func didReceiveOAuthIOResponse(request: OAuthIORequest!) {
        var cred: NSDictionary = request.getCredentials()
        println(cred.objectForKey("oauth_token"))
        println(cred.objectForKey("oauth_token_secret"))
        self.status_label.text = "Logged in with Twitter"
        self.request_object = request
    }
    
    func didFailWithOAuthIOError(error: NSError!) {
        self.status_label.text = "Could not login with twitter"
    }

    
    func didFailAuthenticationServerSide(body: String!, andResponse response: NSURLResponse!, andError error: NSError!) {
        
    }
    
    func didAuthenticateServerSide(body: String!, andResponse response: NSURLResponse!) {
        
    }
    
    func didReceiveOAuthIOCode(code: String!) {
        
    }

}

