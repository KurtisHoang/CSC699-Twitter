//
//  LoginViewController.swift
//  Twitter
//
//  Created by Kurtis Hoang on 2/18/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        //calling the TwitterAPICaller file's functions
        //for login, https://developer.twitter.com/en/docs/basics/authentication/api-reference/request_token
        let myUrl = "https://api.twitter.com/oauth/request_token"
        //if login is a success
        TwitterAPICaller.client?.login(url: myUrl, success: {
            //Save login data
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            //perform segue to home view controller
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        //if login fails
        }, failure: { (Error) in
            print("Could not log in!")
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
