//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Calvin Chu on 2/23/17.
//  Copyright © 2017 Calvin Chu. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
