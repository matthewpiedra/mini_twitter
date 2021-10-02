//
//  TweetCell.swift
//  Twitter
//
//  Created by Matthew Piedra on 9/26/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    var isFavorited = false
    var isRetweeted = false
    var tweetId: Int = -1
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var retweet: UIButton!
    @IBOutlet weak var heart: UIButton!
    @IBOutlet weak var numberOfRetweets: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.roundedImage()
    }
    
    func setRetweet(_ isRetweeted: Bool) {
        self.isRetweeted = isRetweeted
        
        if self.isRetweeted {
            retweet.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        }
        else {
            retweet.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
    }
    
    func setFavorited(_ isFavorited: Bool) {
        self.isFavorited = isFavorited
        
        if self.isFavorited {
            // change image
            heart.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        }
        else {
            heart.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
    }
    
    @IBAction func heartTweet(_ sender: Any) {
        let toBeFavorited = !self.isFavorited
        
        if toBeFavorited {
            // create
            TwitterAPICaller.client?.favoriteTweet(tweetId: self.tweetId, success: {
                self.setFavorited(true)
                
                // increment number of likes
                var numberOfLikes = Int(self.numberOfLikes.text!)
                ?? 0
                numberOfLikes += 1
                self.numberOfLikes.text = String(describing: numberOfLikes)
                
            }, failure: { (error: Error) in
                print("Unable to fav tweet: \(error)")
            })
        }
        else {
            // destroy
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: self.tweetId, success: {
                self.setFavorited(false)
                
                // decrement number of likes
                var numberOfLikes = Int(self.numberOfLikes.text!)
                ?? 0
                numberOfLikes -= 1
                self.numberOfLikes.text = String(describing: numberOfLikes)
            }, failure: { (error: Error) in
                print("Unable to unfav tweet: \(error)")
            })
        }
    }
    
    @IBAction func retweetTweet(_ sender: Any) {
        let toBeRetweeted = !self.isRetweeted
        
        if toBeRetweeted {
            TwitterAPICaller.client?.retweetTweet(tweetId: self.tweetId, success: {
                self.setRetweet(true)
                
                // increment number of retweets
                var numberOfRetweets = Int(self.numberOfRetweets.text!)
                ?? 0
                numberOfRetweets += 1
                self.numberOfRetweets.text = String(describing: numberOfRetweets)
            }, failure: { (error: Error) in
                print(error)
            })
        }
        else {
            TwitterAPICaller.client?.unretweetTweet(tweetId: self.tweetId, success: {
                self.setRetweet(false)
                
                // decrement number of retweets
                var numberOfRetweets = Int(self.numberOfRetweets.text!)
                ?? 0
                numberOfRetweets -= 1
                self.numberOfRetweets.text = String(describing: numberOfRetweets)
            }, failure: { (error: Error) in
                print(error)
            })
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
