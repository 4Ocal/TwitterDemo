//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Calvin Chu on 2/19/17.
//  Copyright © 2017 Calvin Chu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var count = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.11, green: 0.79, blue: 1.00, alpha: 1.0)
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        TwitterClient.sharedInstance?.homeTimeLine(count: count, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            /*
            for tweet in tweets {
                print(tweet.text)
            }
            */
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        if tweet.retweeted! {
            cell.retweetImageView.image = UIImage(named: "retweet-icon-green")
        } else {
            cell.retweetImageView.image = UIImage(named: "retweet-icon")
        }
        if tweet.favorited! {
            cell.favoriteImageView.image = UIImage(named: "favor-icon-red")
        } else {
            cell.favoriteImageView.image = UIImage(named: "favor-icon")
        }
        
        let retweetGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(retweetTapped(tapGestureRecognizer:)))
        cell.retweetImageView.isUserInteractionEnabled = true
        cell.retweetImageView.addGestureRecognizer(retweetGestureRecognizer)
        
        let favoriteGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped(tapGestureRecognizer:)))
        cell.favoriteImageView.isUserInteractionEnabled = true
        cell.favoriteImageView.addGestureRecognizer(favoriteGestureRecognizer)
        
        if let imageUrlString = tweet.profileImageUrlString {
            let imageUrl = URL(string: imageUrlString)
            do {
                let data = try Data(contentsOf: imageUrl!)
                let image = UIImage(data: data)
            cell.profileButton.setBackgroundImage(image, for: UIControlState.normal)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        cell.favoriteLabel.text = tweet.favoriteCount.description
        cell.retweetLabel.text = tweet.retweetCount.description
        cell.timestampLabel.text = TweetsViewController().timeAgoSince(tweet.timestamp!)
        cell.tweetTextLabel.text = tweet.text
        cell.usernameLabel.text = tweet.username
        return cell
    }
    
    func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
    }
    
    func loadMoreData() {
        TwitterClient.sharedInstance?.homeTimeLine(count: count, success: { (tweets: [Tweet]) -> () in
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
            self.tweets = tweets
            self.count += 20
            self.tableView.reloadData()
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()
            }
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.homeTimeLine(count: count, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    
    func retweetTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let buttonPosition:CGPoint = tappedImage.convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        let tweet = tweets[(indexPath?.row)!]
        if tweet.retweeted! {
            TwitterClient.sharedInstance?.unretweet(tweet: tweet, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.homeTimeLine(count: self.count, success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    tappedImage.image = UIImage(named: "retweet-icon")
                    self.tableView.reloadData()
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweet: tweet, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.homeTimeLine(count: self.count, success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    tappedImage.image = UIImage(named: "retweet-icon-green")
                    self.tableView.reloadData()
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
        let buttonPosition:CGPoint = tappedImage.convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        let tweet = tweets[(indexPath?.row)!]
        if tweet.favorited! {
            TwitterClient.sharedInstance?.unfavorite(tweet: tweet, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.homeTimeLine(count: self.count, success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    tappedImage.image = UIImage(named: "favor-icon")
                    self.tableView.reloadData()
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.favorite(tweet: tweet, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.homeTimeLine(count: self.count, success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    tappedImage.image = UIImage(named: "favor-icon-red")
                    self.tableView.reloadData()
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
        if segue.identifier == "detailsSegue" {
            let cell = sender as! TweetCell
            let vc = segue.destination as! TweetDetailsViewController
            let indexPath = tableView.indexPath(for: cell)
            vc.tweet = tweets[(indexPath?.row)!]
        } else if segue.identifier == "profileSegue" {
            let buttonPosition:CGPoint = (sender as! UIButton).convert(CGPoint.zero, to: self.tableView)
            let indexPath = tableView.indexPathForRow(at: buttonPosition)
            let tweet = tweets[(indexPath?.row)!]
            let vc = segue.destination as! ProfileViewController
            vc.tweet = tweet
        } else if segue.identifier == "tweetsToCompose" {
            let buttonPosition:CGPoint = (sender as! UIButton).convert(CGPoint.zero, to: self.tableView)
            let indexPath = tableView.indexPathForRow(at: buttonPosition)
            let tweet = tweets[(indexPath?.row)!]
            let vc = segue.destination as! ComposeViewController
            vc.tweet = tweet
            vc.reply = true
        }
        
        
    }
    

}
