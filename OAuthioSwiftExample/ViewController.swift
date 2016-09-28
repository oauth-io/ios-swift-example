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
        //let key : String = "t5V_SJD4lJWbZuE6fsBD_7p0Vqg"
         let key: String = "lP9cZJ_4LiOJmo03x26ZZ1B9iWI"
        self.oauth_modal = OAuthIOModal(key: key, delegate: self)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func LoginClick() {
        self.status_label.text = "Logging in with Twitter"
        let options = NSMutableDictionary()
        options.setValue("true", forKey: "cache")
        self.oauth_modal?.show(withProvider:"twitter", options: options as [NSObject : AnyObject])
    }
    @IBAction func RequestClick() {
        let cache_available = self.oauth_modal?.cacheAvailable(forProvider:"twitter")
        if cache_available! {
            self.status_label.text = "Getting personal info from Twitter"
            self.name_label.text = "Retrieving..."
            self.request_object?.me(nil, success: { (respDictionary, body, response) -> Void in
                let dictionary: Dictionary? = respDictionary
                self.status_label.text = "Successfully got info from Twitter"
                self.name_label.text = dictionary?["name"] as? String
            })
        } else {
            self.status_label.text = "Not logged in"
        }
    }
    @IBAction func LogoutClick() {
        let cache_available = self.oauth_modal?.cacheAvailable(forProvider:"twitter")
        if cache_available! {
            self.oauth_modal?.clearCache()
            self.status_label.text = "Logged out"
        } else {
            self.status_label.text = "Not logged in"
        }
    }



    func didReceiveOAuthIOResponse(_ request: OAuthIORequest!) {
        var cred: Dictionary = request.getCredentials()
        print(cred["oauth_token"])
        print(cred["oauth_token_secret"])
        self.status_label.text = "Logged in with Twitter"
        self.request_object = request
    }
    
    func didFailWithOAuthIOError(error: NSError!) {
        self.status_label.text = "Could not login with twitter"
    }

    
    func didFailAuthenticationServerSide(_ body: String!, andResponse response: URLResponse!, andError error: Error!) {
        
    }
    
    func didAuthenticateServerSide(_ body: String!, andResponse response: URLResponse!) {
        
    }
    
    func didReceiveOAuthIOCode(_ code: String!) {
        
    }
    
    func didFail(withOAuthIOError error: Error!) {

    }
}

