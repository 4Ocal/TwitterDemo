//
//  TweetDetailsViewController.swift
//  TwitterDemo
//
//  Created by Calvin Chu on 3/5/17.
//  Copyright © 2017 Calvin Chu. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UITableViewController {
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 100
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = "Tweet"
        
        if (tweet?.retweeted!)! {
            retweetImageView.image = UIImage(named: "retweet-icon-green")
        } else {
            retweetImageView.image = UIImage(named: "retweet-icon")
        }
        if (tweet?.favorited!)! {
            favoriteImageView.image = UIImage(named: "favor-icon-red")
        } else {
            favoriteImageView.image = UIImage(named: "favor-icon")
        }
        
        let retweetGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweetsViewController.retweetTapped(tapGestureRecognizer:)))
        retweetImageView.isUserInteractionEnabled = true
        retweetImageView.addGestureRecognizer(retweetGestureRecognizer)
        
        let favoriteGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweetsViewController.favoriteTapped(tapGestureRecognizer:)))
        favoriteImageView.isUserInteractionEnabled = true
        favoriteImageView.addGestureRecognizer(favoriteGestureRecognizer)
        
        if let imageUrlString = tweet?.profileImageUrlString {
            let imageUrl = URL(string: imageUrlString)
            profileImageView.setImageWith(imageUrl!)
        }
        
        favoriteLabel.text = tweet?.favoriteCount.description
        retweetLabel.text = tweet?.retweetCount.description
        timestampLabel.text = TweetsViewController().timeAgoSince((tweet?.timestamp!)!)
        tweetTextLabel.text = tweet?.text
        usernameLabel.text = tweet?.username
        screennameLabel.text = "@\((tweet?.screenname)!)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 350
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func retweetTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if (tweet?.retweeted!)! {
            TwitterClient.sharedInstance?.unretweet(tweet: tweet!, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.homeTimeLine(count: TweetsViewController().count, success: { (tweets: [Tweet]) -> () in
                    TweetsViewController().tweets = tweets
                    for tweet in tweets {
                        if tweet.id_str == self.tweet?.id_str {
                            self.tweet = tweet
                        }
                    }
                    tappedImage.image = UIImage(named: "retweet-icon")
                    self.retweetLabel.text = String(Int(self.retweetLabel.text!)! - 1)
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweet: tweet!, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.homeTimeLine(count: TweetsViewController().count, success: { (tweets: [Tweet]) -> () in
                    TweetsViewController().tweets = tweets
                    for tweet in tweets {
                        if tweet.id_str == self.tweet?.id_str {
                            self.tweet = tweet
                        }
                    }
                    tappedImage.image = UIImage(named: "retweet-icon-green")
                    self.retweetLabel.text = String(Int(self.retweetLabel.text!)! + 1)
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        }
    }
    
    func favoriteTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if (tweet?.favorited!)! {
            TwitterClient.sharedInstance?.unfavorite(tweet: tweet!, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.homeTimeLine(count: TweetsViewController().count, success: { (tweets: [Tweet]) -> () in
                    for tweet in tweets {
                        if tweet.id_str == self.tweet?.id_str {
                            self.tweet = tweet
                        }
                    }
                    tappedImage.image = UIImage(named: "favor-icon")
                    self.favoriteLabel.text = String(Int(self.favoriteLabel.text!)! - 1)
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.favorite(tweet: tweet!, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.homeTimeLine(count: TweetsViewController().count, success: { (tweets: [Tweet]) -> () in
                    for tweet in tweets {
                        if tweet.id_str == self.tweet?.id_str {
                            self.tweet = tweet
                        }
                    }
                    tappedImage.image = UIImage(named: "favor-icon-red")
                    self.favoriteLabel.text = String(Int(self.favoriteLabel.text!)! + 1)
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! ComposeViewController
        vc.tweet = tweet
        vc.reply = true
    }
    

}
