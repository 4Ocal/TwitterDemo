//
//  User.swift
//  TwitterDemo
//
//  Created by Calvin Chu on 2/19/17.
//  Copyright © 2017 Calvin Chu. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenname: String?
    var profileUrlString: String?
    var tagline: String?
    var userId: String?
    var followersCount: Int?
    var followingCount: Int?
    var tweetsCount: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        tagline = dictionary["description"] as? String
        userId = dictionary["id_str"] as? String
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
        
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            let defaults = UserDefaults.standard
            let userData = defaults.object(forKey: "currentUserData") as? Data
            if let userData = userData {
                if let dict = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as? NSDictionary {
                    //print(dict)
                    _currentUser = User(dictionary: dict)
                } else {
                    _currentUser = nil
                }
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = _currentUser {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary ?? [], options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
        
            defaults.synchronize()
        }
    }
}
