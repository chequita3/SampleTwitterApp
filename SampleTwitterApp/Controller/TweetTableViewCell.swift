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

    @IBOutlet  weak var iconImageView: UIImageView!
    @IBOutlet  weak var userNameLabel: UILabel!
    @IBOutlet  weak var tweetLabel: UILabel!
    
//    外部（Item構造体から）からデータを受け取って、Outletを通じてviewに反映させる
    func configure(item: Item) {
        iconImageView.image = item.icon
        userNameLabel.text = item.name
        tweetLabel.text = item.tweet
        }
            }





