//
//  TweetSearchAPIHelper.swift
//  Tweets
//
//  Created by Engin Yıldız on 23/10/2017.
//  Copyright © 2017 Engin Yıldız. All rights reserved.
//

import UIKit
import TwitterKit

let searchAPIEndPoint = "https://api.twitter.com/1.1/search/tweets.json"
let dataBlockCount = "20"

let hashtag = "Apple"
let user = "AppleEDU"

class TweetSearchAPIHelper: NSObject {
    
    class func getAppleHashtagTweets(_ isLocalLanguage: Bool, nextResults: String?, completionHandler: @escaping (NSArray, String?) -> Void, failHandler: @escaping (String?) -> Void) {
        LoadingView.startSpinner()
        
        let client = TWTRAPIClient()
        var clientError: NSError?
        
        let langKey = ((Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String)
        let params = isLocalLanguage ? ["q": "#" + "\(hashtag)", "result_type": "recent", "lang": langKey, "count": dataBlockCount] : ["q": "#apple", "result_type": "recent", "count": dataBlockCount]
        
        let request = client.urlRequest(withMethod: "GET", url: searchAPIEndPoint + (nextResults != nil ? nextResults! : ""), parameters: params, error: &clientError)
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            guard connectionError == nil else {
                failHandler("\(connectionError!)")
                
                LoadingView.stopSpinner()
                
                return
            }
            
            do {
                let JSONResult: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                let statuses: NSArray? = JSONResult["statuses"] as? NSArray
                
                guard statuses != nil || statuses!.count > 0 else {
                    failHandler("Empty response from Twitter.")
                    
                    LoadingView.stopSpinner()
                    
                    return
                }
                
                completionHandler(statuses!, ((JSONResult["search_metadata"] as! NSDictionary)["next_results"] as? String))
                
                LoadingView.stopSpinner()
            }
            catch let jsonError as NSError {
                failHandler("\(jsonError.localizedDescription)")
                
                LoadingView.stopSpinner()
            }
        }
    }
    
    class func getAppleUserTweets(_ nextResults: String?, completionHandler: @escaping (NSArray, String?) -> Void, failHandler: @escaping (String?) -> Void) {
        LoadingView.startSpinner()
        
        let client = TWTRAPIClient()
        var clientError: NSError?
        
        let params = ["q": "from:" + "\(user)",
                      "result_type": "recent",
                      "count": dataBlockCount]
        
        let request = client.urlRequest(withMethod: "GET", url: searchAPIEndPoint + (nextResults != nil ? nextResults! : ""), parameters: params, error: &clientError)
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            guard connectionError == nil else {
                failHandler("\(connectionError!)")
                
                LoadingView.stopSpinner()
                
                return
            }
            
            do {
                let JSONResult: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                let statuses: NSArray? = JSONResult["statuses"] as? NSArray
                
                guard statuses != nil || statuses!.count > 0 else {
                    failHandler("Empty response from Twitter.")
                    
                    LoadingView.stopSpinner()
                    
                    return
                }
                
                completionHandler(statuses!, ((JSONResult["search_metadata"] as! NSDictionary)["next_results"] as? String))
                
                LoadingView.stopSpinner()
            }
            catch let jsonError as NSError {
                failHandler("\(jsonError.localizedDescription)")
                
                LoadingView.stopSpinner()
            }
        }
    }
}

