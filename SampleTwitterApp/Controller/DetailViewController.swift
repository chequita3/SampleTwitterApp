//
//  DetailViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2022/01/12.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    var userName = String()
    var profileImageString = String()
    var tweet = String()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = 40
        profileImageView.sd_setImage(with: URL(string: profileImageString), completed: nil)
        userNameLabel.text = userName
        tweetTextLabel.text = tweet
    }
    



}
