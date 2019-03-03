//
//  User.swift
//  Twitter
//
//  Created by Kurtis Hoang on 3/2/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class User {
    
    let name: String
    let screenName:String
    let profileImage: URL
    //let bannerImage: URL
    let followers: Int
    let following: Int
    
    var dictionary: NSDictionary?
    static var current_User: User?
    
    var currentUser: User? {
        get {
            if User.current_User == nil {
                if let userData = UserDefaults.standard.data(forKey: "currentUser") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    User.current_User = User(dict: dictionary)
                }
            }
            
            return User.current_User
        }
        
        set(user) {
            User.current_User = user
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                UserDefaults.standard.set(data, forKey: "currentUser")
            }
            else {
                UserDefaults.standard.removeObject(forKey: "currentUser")
            }
        }
    }
    
    init(dict: NSDictionary)
    {
        dictionary = dict
        name = dict["name"] as! String
        screenName = dict["screen_name"] as! String
        let profileImageString = dict["profile_image_url"] as! String
        profileImage = URL(string: profileImageString)!
        //let bannerImageString = dictionary["profile_banner_url"] as! String
        //bannerImage = URL(string: bannerImageString)!
        followers = dict["followers_count"] as! Int
        following = dict["friends_count"] as! Int
    }
}
