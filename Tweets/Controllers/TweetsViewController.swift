//
//  TweetsViewController.swift
//  Tweets
//
//  Created by Engin Yıldız on 23/10/2017.
//  Copyright © 2017 Engin Yıldız. All rights reserved.
//

import UIKit

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tweetCellIdentifier, for: indexPath) as! TweetTableViewCell
        cell.frame.size = CGSize(width: tweetsTableView.frame.width, height: cell.frame.height)
        cell.customizeTweetCell(tweetList[indexPath.row] as! TweetObject)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == tweetList.count - 2 {
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            activityIndicatorView.startAnimating()
            activityIndicatorView.hidesWhenStopped = true
            tweetsTableView.tableFooterView = activityIndicatorView
            
            if appleHashtagNextResults != nil {
                getMoreAppleHashtagTweets(appleHashtagNextResults, completionHandler: {
                    guard self.appleUserNextResults != nil else {
                        self.tweetsTableView.reloadData()
                        
                        return
                    }
                    
                    self.getMoreAppleUserTweets(self.appleUserNextResults)
                })
            }
            else {
                guard appleUserNextResults != nil else {
                    return
                }
                
                getMoreAppleUserTweets(appleUserNextResults)
            }
        }
    }
}

class TweetsViewController: UIViewController {
    @IBOutlet weak var tweetsTableView: UITableView!
    
    var tweetList: NSMutableArray = NSMutableArray()
    var appleHashtagNextResults: String!
    var appleUserNextResults: String!
    
    let tweetCellIdentifier = "tweetCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsTableView.register(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: tweetCellIdentifier)
        
        guard UtilityMethods.isConnectedToNetwork() else {
            print("Please connect to the Internet in order to fetch tweets.")
            
            return
        }
        
        getAppleHashtagTweets(completionHandler: {
            self.tweetsTableView.isHidden = false
            
            self.getAppleUserTweets()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Tweets"
        
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAppleHashtagTweets(completionHandler: @escaping () -> Void) {
        TweetSearchAPIHelper.getAppleHashtagTweets(false, nextResults: nil, completionHandler: { statuses, nextResults  in
            for index in 0..<statuses.count {
                let tweetObject: TweetObject = TweetObject()
                tweetObject.initWithStatusData(statuses[index] as! NSDictionary)
                
                self.tweetList.add(tweetObject)
            }
            
            self.appleHashtagNextResults = nextResults
            
            completionHandler()
        }, failHandler: { failResponse in
            print(failResponse!)
        })
    }
    
    func getAppleUserTweets() {
        TweetSearchAPIHelper.getAppleUserTweets(nil, completionHandler: { statuses, nextResults in
            for index in 0..<statuses.count {
                let tweetObject: TweetObject = TweetObject()
                tweetObject.initWithStatusData(statuses[index] as! NSDictionary)
                
                self.tweetList.add(tweetObject)
            }
            
            self.appleUserNextResults = nextResults
            
            self.tweetsTableView.reloadData()
        }, failHandler: { failResponse in
            print(failResponse!)
        })
    }
    
    func getMoreAppleHashtagTweets(_ nextResults: String, completionHandler: @escaping () -> Void) {
        TweetSearchAPIHelper.getAppleHashtagTweets(false, nextResults: nextResults, completionHandler: { statuses, nextResults in
            for index in 0..<statuses.count {
                let tweetObject: TweetObject = TweetObject()
                tweetObject.initWithStatusData(statuses[index] as! NSDictionary)
                
                self.tweetList.add(tweetObject)
            }
            
            self.appleHashtagNextResults = nextResults
            
            completionHandler()
        }, failHandler: { failResponse in
            print(failResponse!)
        })
    }
    
    func getMoreAppleUserTweets(_ nextResults: String) {
        TweetSearchAPIHelper.getAppleUserTweets(nextResults, completionHandler: { statuses, nextResults in
            for index in 0..<statuses.count {
                let tweetObject: TweetObject = TweetObject()
                tweetObject.initWithStatusData(statuses[index] as! NSDictionary)
                
                self.tweetList.add(tweetObject)
            }
            
            self.appleUserNextResults = nextResults
            
            self.tweetsTableView.reloadData()
        }, failHandler: { failResponse in
            print(failResponse!)
        })
    }

}
