//
//  TweetViewController.swift
//  Twitter
//
//  Created by Matthew Piedra on 9/30/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    func textViewDidChange(_ textView: UITextView) {
        // increment
        var count = Int(self.textCount.text!)
        ?? 0
        count = self.tweetTextView.text.count
        self.textCount.text = String(describing: count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.delegate = self

        // Do any additional setup after loading the view.
        tweetTextView.becomeFirstResponder()
        tweetTextView.clipsToBounds = true
        tweetTextView.layer.cornerRadius = 10.0
        
        if #available(iOS 13.0, *) {
            tweetTextView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            tweetTextView.layer.borderWidth = 2
        }
        
        profilePic.roundedImage()
        
        let userID = UserDefaults.standard.string(forKey: "userID")!
        
        TwitterAPICaller.client?.getUser(userID: userID, success: { (user: NSDictionary) in
            // set proifle image
            let imageUrl = URL(string: user["profile_image_url_https"] as! String)!

            // Setting an image in Xcode without 3rd party library
            let data = try? Data(contentsOf: imageUrl)

            if let imageData = data {
                self.profilePic.image = UIImage(data: imageData)
            }
        }, failure: { (error: Error) in
            print(error)
        })
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        // post request to tweet using the twitter api
        if !tweetTextView.text.isEmpty {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) in
                print("unable to compose tweet: \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        }
        else {
            let alertController = UIAlertController.init(title: "Empty tweet", message: "Please enter some text to compose", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let tweetLimit = 280
        
        // if the tweet is longer than 280 characters, then halt text
        if range.length + range.location > self.tweetTextView.text.count {
            return false
        }
        
        let newString = self.tweetTextView.text.count + text.count - range.length
        
        return newString <= tweetLimit
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
