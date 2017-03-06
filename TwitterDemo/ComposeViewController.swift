//
//  ComposeViewController.swift
//  TwitterDemo
//
//  Created by Calvin Chu on 3/6/17.
//  Copyright © 2017 Calvin Chu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var tweetTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    
    var tweet: Tweet?
    var reply: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if reply! {
            if let imageUrlString = tweet?.profileImageUrlString {
                let imageUrl = URL(string: imageUrlString)
                profileImageView.setImageWith(imageUrl!)
            }
            usernameLabel.text = tweet?.username
            screennameLabel.text = "@\((tweet?.screenname)!)"
        } else {
            let user: User = User.currentUser!
            if let imageUrlString = user.profileUrlString {
                let imageUrl = URL(string: imageUrlString)
                profileImageView.setImageWith(imageUrl!)
            }
            usernameLabel.text = user.name
            screennameLabel.text = "@\((user.screenname)!)"
        }
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tweet(_ sender: Any) {
        if reply! {
            TwitterClient.sharedInstance?.reply(status: tweetTextField.text!, tweet: tweet!, success: { (tweet: Tweet) in
                print("replied")
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.update(status: tweetTextField.text!, success: { (tweet: Tweet) in
                print("tweeted")
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
