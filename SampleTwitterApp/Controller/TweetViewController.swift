//
//  TweetViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/10/23.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class TweetViewController:UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBAction func tweetButton(_ sender: Any) {
        
        if tweetTextView.text != nil {
        db.collection("tweet").document().setData(["tweet": tweetTextView.text as Any,"postDate": Date().timeIntervalSince1970])
        

        self.performSegue(withIdentifier: "toTimeLineViewController", sender: self)
        }
    }
}
