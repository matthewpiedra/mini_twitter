//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Matthew Piedra on 9/26/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweets = [NSDictionary]()
    var numberOfTweets = Int()
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTweets()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        
        tableView.refreshControl = myRefreshControl
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(1)
        if indexPath.row + 1 == tweets.count {
            loadMoreTweets()
        }
    }
    
    func loadMoreTweets() {
        numberOfTweets = numberOfTweets + 10
        
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        let params = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params) { (tweets_res: [NSDictionary]) in
            
            for tweet in tweets_res {
                self.tweets.append(tweet)
            }
            
            self.tableView.reloadData()
        } failure: { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    @objc func loadTweets() {
        numberOfTweets = 10
        
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        let params = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params) { (tweets_res: [NSDictionary]) in
            
            // Add reload functionality
            self.tweets.removeAll()
            
            for tweet in tweets_res {
                self.tweets.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        } failure: { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onSIgnOutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let cellIndex = indexPath.row
        
        let user = tweets[cellIndex]["user"] as! NSDictionary
        let tweet = (tweets[cellIndex]["text"] as! String)
        let imageUrl = URL(string: user["profile_image_url_https"] as! String)!

        // Configure the cell to display the proper profile pic, username, and tweetcontent
        cell.userNameLabel.text = (user["name"] as! String)
        cell.tweetContentLabel.text = tweet
        
        // Setting an image in Xcode without 3rd party library
        let data = try? Data(contentsOf: imageUrl)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
