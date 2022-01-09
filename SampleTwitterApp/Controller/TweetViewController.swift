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
import FirebaseStorageUI

class TweetViewController:UIViewController {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    

    
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var sampleImage: UIImageView!
    
        let reference = Storage.storage().reference(withPath: "profileImage/O9zHZVTHCLem65MDGF70y3I3Xng2.jpg")
        let placeholderImage = UIImage(named: "placeholder.jpg")
    
    
    @IBAction func get(_ sender: Any) {
        sampleImage.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }

    @IBAction func tweetButton(_ sender: Any) {
        
        if tweetTextView.text != nil {
            db.collection("tweet").document(self.user!.uid).setData(["postDate": Timestamp(date: Date()),"tweet": tweetTextView.text as String])
        

        self.performSegue(withIdentifier: "toTimeLineViewController", sender: self)
        }
    }
}
