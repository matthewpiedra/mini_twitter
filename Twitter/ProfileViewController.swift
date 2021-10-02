//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Matthew Piedra on 10/1/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var numOfTweets: UILabel!
    @IBOutlet weak var numOfFollowing: UILabel!
    @IBOutlet weak var numOfFollowers: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImg.roundedImage()
        
        let userID = UserDefaults.standard.string(forKey: "userID")!
        
        TwitterAPICaller.client?.getUser(userID: userID, success: { (user: NSDictionary) in
            let bio = user["description"] as! String
            let tweetCount = user["statuses_count"] as! Int
            let followingCount = user["friends_count"] as! Int
            let followersCount = user["followers_count"] as! Int
            
            let imageUrl = URL(string: user["profile_image_url_https"] as! String)!
                    
            // Setting an image in Xcode without 3rd party library
            let data = try? Data(contentsOf: imageUrl)
            
            if let imageData = data {
                self.profileImg.image = UIImage(data: imageData)
            }
            
            self.tagline.text = bio
            self.numOfTweets.text = "Tweets: " + String(describing: tweetCount)
            self.numOfFollowing.text = "Following: " + String(describing: followingCount)
            self.numOfFollowers.text = "Followers: " + String(describing: followersCount)
            
        }, failure: { (error: Error) in
            print(error)
        })
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
