//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Calvin Chu on 3/5/17.
//  Copyright © 2017 Calvin Chu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = tweet?.username
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit-icon"), style: .plain, target: self, action: #selector(compose))
        
        let headerView = UIView(frame: CGRect(x: 0, y: 64, width: 320, height: 160))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        TwitterClient.sharedInstance?.profileBanner(tweet: tweet!, success: { (urlString: String) -> () in
            let bannerUrl = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            if let url = bannerUrl {
                let bannerView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 160))
                bannerView.clipsToBounds = true
                bannerView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
                bannerView.layer.borderWidth = 1;
                bannerView.setImageWith(url)
                headerView.addSubview(bannerView)
                headerView.sendSubview(toBack: bannerView)
            }
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
        
        let profileView = UIImageView(frame: CGRect(x: 138.5, y: 20, width: 45, height: 45))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 3;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        if let imageUrlString = self.tweet?.profileImageUrlString {
            let imageUrl = URL(string: imageUrlString)
            profileView.setImageWith(imageUrl!)
        }
        headerView.addSubview(profileView)
        
        let usernameView = UILabel(frame: CGRect(x: 0, y: 72.5, width: 320, height: 21))
        usernameView.textColor = UIColor.white
        usernameView.font = usernameView.font.withSize(17)
        usernameView.textAlignment = .center
        usernameView.text = self.tweet?.username
        headerView.addSubview(usernameView)
        
        let screennameView = UILabel(frame: CGRect(x: 0, y: 92.5, width: 320, height: 15))
        screennameView.textColor = UIColor.white
        screennameView.font = screennameView.font.withSize(13)
        screennameView.textAlignment = .center
        screennameView.text = "@\((self.tweet?.screenname)!)"
        headerView.addSubview(screennameView)
        
        self.view.addSubview(headerView)
        
        let user = User(dictionary: (tweet?.user)!)
        tweetsCountLabel.text = user.tweetsCount?.description
        followersCountLabel.text = user.followersCount?.description
        followingCountLabel.text = user.followingCount?.description
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func compose() {
        print("compose")
        let vc = ComposeViewController()
        vc.tweet = tweet
        vc.reply = false
        //self.navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    */
 
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! ComposeViewController
        vc.tweet = tweet
        vc.reply = false
    }
    

}
