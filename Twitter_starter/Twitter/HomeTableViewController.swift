//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Kurtis Hoang on 2/18/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    var myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        
        //tie an action to myRefreshControl
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        //set tableview's refreshControl
        tableView.refreshControl = myRefreshControl
        //automatic cell height
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweet()
    }
    
    @objc func loadTweet()
    {
        
        numberOfTweets = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets] //["count": 20, "id" : 34]
        
        //call api for multiple disctionaries of tweets
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            //remove all current tweets
            self.tweetArray.removeAll()
            
            //append new tweets
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            //reload data
            self.tableView.reloadData()
            
            //end refresh
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Failed to get tweets!")
        })
    }
    
    func loadMoreTweets() {
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets += 20
        let myParams = ["count": numberOfTweets]
        
        //call api for multiple disctionaries of tweets
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            //remove all current tweets
            self.tweetArray.removeAll()
            
            //append new tweets
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            //reload data
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Failed to get tweets!")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //check if at the last cell
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //initialize cell of TweetCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        //set username and tweet content
        cell.userNameLabel.text = (user["name"] as! String)
        cell.tweetContentLabel.text = (tweetArray[indexPath.row]["text"] as! String)
        
        //get imageURL and set it to cell profileImageView using AlamoFireImage
        let imageUrl = URL(string: user["profile_image_url"] as! String)
        cell.profileImageView.af_setImage(withURL: imageUrl!)
        
//        getting the date / time
//        let twitterTimestamp = tweetArray[indexPath.row]["created_at"] as! String
//        let tdf = DateFormatter()
//        tdf.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
//        //tdf.doesRelativeDateFormatting = true
//        let date = tdf.date(from: twitterTimestamp)
//        if Date().timeIntervalSince(date!) > 24*60*60
//        {
//            tdf.dateStyle = .short
//        }
//        else
//        {
//            tdf.timeStyle = .short
//        }
//        let createdTime = tdf.string(from: date!)
//        cell.tweetTime.text = createdTime

        //get relative time for tweetTime
        cell.tweetTime.text = getRelativeTime(timeString: (tweetArray[indexPath.row]["created_at"] as! String))
        
        //set boolean favorited
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        
        //pass retweeted boolean
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        //pass id to cell
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        return cell
    }
    
    func getRelativeTime(timeString: String) -> String {
        let time: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        time = dateFormatter.date(from: timeString)!
        return time.timeAgoDisplay()
    }
    
    @IBAction func onLogout(_ sender: Any) {
        //logout function
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        //will dismiss the current table view controller
        self.dismiss(animated: true, completion: nil)
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

//extend date
extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        //check how long ago
        if secondsAgo < minute {
            return "\(secondsAgo) sec ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) min ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hrs ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) days ago"
        }
        
        return "\(secondsAgo / week) weeks ago"
    }
}
