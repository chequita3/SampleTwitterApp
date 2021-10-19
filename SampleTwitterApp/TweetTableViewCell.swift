//
//  TweetTableViewCell.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/08/09.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class TweetTableViewCell: UITableViewCell{

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var tweetLabel: UILabel!
    
    func configure(item: Item) {
        iconImageView.image = item.icon
        userNameLabel.text = item.name
        tweetLabel.text = item.tweet
        }
            }





