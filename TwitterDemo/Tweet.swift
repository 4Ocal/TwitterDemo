//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Calvin Chu on 2/19/17.
//  Copyright © 2017 Calvin Chu. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var username: String?
    var profileImageUrlString: String?
    
    init(dictionary: NSDictionary) {
        print(dictionary)
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        let user = dictionary["user"] as? NSDictionary
        if let user = user {
            username = user["name"] as? String
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
