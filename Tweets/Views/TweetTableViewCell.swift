//
//  TweetTableViewCell.swift
//  Tweets
//
//  Created by Engin Yıldız on 23/10/2017.
//  Copyright © 2017 Engin Yıldız. All rights reserved.
//

import UIKit
import SDWebImage

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var userTweetInfoLabel: UILabel!
    @IBOutlet weak var userTweetInfoLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetRetweetCountLabel: UILabel!
    @IBOutlet weak var tweetFavoriteCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.size.height / 2
    }
    
    func customizeTweetCell(_ tweetObject: TweetObject) {
        userProfileImageView.image = nil
        retweetedLabel.text = nil
        userTweetInfoLabel.text = nil
        tweetTextLabel.text = nil
        tweetRetweetCountLabel.text = nil
        tweetFavoriteCountLabel.text = nil
        
        if let userProfileImageURL: URL = URL(string: tweetObject.getUserProfileImageURL()) {
            userProfileImageView.sd_setImage(with: userProfileImageURL, placeholderImage: nil, options: [], completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                if image != nil {
                    self.userProfileImageView.image = image
                }
            })
        }
        else {
            print("Image not found")
        }
        
        if tweetObject.getRetweetedUserName() != nil {
            retweetedLabel.text = tweetObject.getRetweetedUserName()! + " Retweeted"
        }
        else {
            userTweetInfoLabelTopConstraint.constant = 0
        }
        
        let regularFontAttribute = [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue", size: 14.0)!]
        let mediumFontAttribute = [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Medium", size: 14.0)!]
        
        let userTweetInfoText: NSMutableAttributedString = NSMutableAttributedString(string: tweetObject.getUserName() + " " + tweetObject.getUserScreenName() + " • " + tweetObject.getTweetCreatedAt(), attributes: mediumFontAttribute)
        var foundRange = userTweetInfoText.mutableString.range(of: tweetObject.getUserName()) // User name
        userTweetInfoText.addAttributes(mediumFontAttribute, range: foundRange)
        userTweetInfoText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: foundRange)
        foundRange = userTweetInfoText.mutableString.range(of: tweetObject.getUserScreenName() + " • " + tweetObject.getTweetCreatedAt()) // User screen name • Tweet created at
        userTweetInfoText.addAttributes(regularFontAttribute, range: foundRange)
        userTweetInfoText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: foundRange)
        userTweetInfoLabel.attributedText = userTweetInfoText
        
        tweetTextLabel.text = tweetObject.getTweetText()
        tweetRetweetCountLabel.text = String(tweetObject.getTweetRetweetCount())
        tweetFavoriteCountLabel.text = String(tweetObject.getTweetFavoriteCount())
    }
}
