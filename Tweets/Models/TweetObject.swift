//
//  TweetObject.swift
//  Tweets
//
//  Created by Engin Yıldız on 23/10/2017.
//  Copyright © 2017 Engin Yıldız. All rights reserved.
//

import UIKit

class TweetObject: NSObject {
    var retweetedUserName: String?
    var tweetText: String!
    var tweetCreatedAt: String!
    var tweetRetweetCount: Int!
    var userName: String!
    var userScreenName: String!
    var userProfileImageURL: String!
    
    func initWithStatusData(_ statusData: NSDictionary) {
        let userData: NSDictionary = statusData["user"] as! NSDictionary
        let retweetedStatusData: NSDictionary? = statusData["retweeted_status"] as? NSDictionary
        
        if retweetedStatusData != nil {
            let retweetedUserData: NSDictionary = retweetedStatusData!["user"] as! NSDictionary
            
            retweetedUserName = userData["name"] as? String
            userName = retweetedUserData["name"] as! String
            userScreenName = retweetedUserData["screen_name"] as! String
            userProfileImageURL = retweetedUserData["profile_image_url"] as! String
        }
        else {
            userName = userData["name"] as! String
            userScreenName = userData["screen_name"] as! String
            userProfileImageURL = userData["profile_image_url"] as! String
        }
        
        tweetText = statusData["text"] as! String
        tweetCreatedAt = convertTimestamp(statusData["created_at"] as! String)
        tweetRetweetCount = statusData["retweet_count"] as! Int
    }
    
    func getRetweetedUserName() -> String? {
        return retweetedUserName
    }
    
    func getTweetText() -> String {
        return tweetText
    }
    
    func getTweetCreatedAt() -> String {
        return tweetCreatedAt
    }
    
    func getTweetRetweetCount() -> Int {
        return tweetRetweetCount
    }
    
    func getUserName() -> String {
        return userName
    }
    
    func getUserScreenName() -> String {
        return "@" + userScreenName
    }
    
    func getUserProfileImageURL() -> String {
        return userProfileImageURL
    }
    
    func convertTimestamp(_ date: String) -> String {
        let timestampDate = UtilityMethods.getDateFormatter().date(from: date)!
        let differenceComponenets = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: timestampDate, to: Date())
        
        if differenceComponenets.year! > 0 {
            return String(describing: differenceComponenets.year!) + "y"
        }
        else if differenceComponenets.month! > 0 {
            return String(describing: differenceComponenets.month!) + "m"
        }
        else if differenceComponenets.day! > 0 {
            return String(describing: differenceComponenets.day!) + "d"
        }
        else if differenceComponenets.hour! > 0 {
            return String(describing: differenceComponenets.hour!) + "h"
        }
        else if differenceComponenets.minute! > 0 {
            return String(describing: differenceComponenets.minute!) + "m"
        }
        else if differenceComponenets.second! > 0 {
            return String(describing: differenceComponenets.second!) + "s"
        }
        else {
            return ""
        }
    }
}
