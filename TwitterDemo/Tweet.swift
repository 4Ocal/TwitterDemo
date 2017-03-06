//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Calvin Chu on 2/19/17.
//  Copyright © 2017 Calvin Chu. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var current_user_retweet: Tweet?
    var id_str: String?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var retweeted: Bool?
    var retweeted_status: Tweet?
    var favoriteCount: Int = 0
    var favorited: Bool?
    var user: NSDictionary?
    var username: String?
    var profileImageUrlString: String?
    var screenname: String?
    
    init(dictionary: NSDictionary) {
        print(dictionary)
        let current_user_retweet_dict = (dictionary["current_user_retweet"] as? NSDictionary) ?? nil
        if current_user_retweet_dict != nil {
            current_user_retweet = Tweet(dictionary: current_user_retweet_dict!)
        } else {
            current_user_retweet = nil
        }
        id_str = dictionary["id_str"] as? String
        
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = dictionary["retweeted"] as? Bool
        let retweeted_status_dict = (dictionary["retweeted_status"] as? NSDictionary) ?? nil
        if retweeted_status_dict != nil {
            retweeted_status = Tweet(dictionary: retweeted_status_dict!)
        } else {
            retweeted_status = nil
        }
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        favorited = dictionary["favorited"] as? Bool
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        user = dictionary["user"] as? NSDictionary
        if let user = user {
            username = user["name"] as? String
            screenname = user["screen_name"] as? String
            profileImageUrlString = user["profile_image_url_https"] as? String
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        return tweets
    }
}
