//
//  TweetCell.swift
//  Twitter
//
//  Created by Kurtis Hoang on 2/18/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var tweetTime: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var tweetId:Int = -1
    var favorited:Bool = false
    var retweeted:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFavorite(_ isFavorited:Bool)
    {
        favorited = isFavorited
        if(favorited)
        {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else{
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted:Bool)
    {
        retweeted = isRetweeted
        if(retweeted)
        {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }
        else
        {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }

    @IBAction func favTweet(_ sender: Any) {
        let tobeFavorited = !favorited
        if tobeFavorited {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                //favorited & change image
                self.setFavorite(true)
            }, failure: { (Error) in
                print("Favorite did not succeed: \(Error)")
            })
        }
        else
        {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                //no longer favorited & change image
                self.setFavorite(false)
            }, failure: { (Error) in
                print("Unfavorite did not succeed: \(Error)")
            })
        }
    }

    @IBAction func reTweet(_ sender: Any) {
        let tobeRetweeted = !retweeted
        if tobeRetweeted {
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                //retweeted & change image
                self.setRetweeted(true)
            }, failure: { (Error) in
                print("Retweet did not succeed: \(Error)")
            })
        }
        else
        {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                //no longer retweeted & change image
                self.setRetweeted(false)
            }, failure: { (Error) in
                print("undo retweet did not succeed: \(Error)")
            })
        }
    }
}
