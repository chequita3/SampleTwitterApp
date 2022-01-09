//
//  TweetTableViewCell.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/12/20.
//

import Foundation
import UIKit

final class TweetTableViewCell :UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tweet: UILabel!
    
    func configure(contents: Contents) {
        icon.image = contents.icon
        name.text = contents.name
        tweet.text = contents.tweet
    }
}
