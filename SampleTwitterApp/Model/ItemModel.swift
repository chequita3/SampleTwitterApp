//
//  ItemModel.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/11/06.
//

import Foundation
import UIKit
import FirebaseFirestore

class Item: NSObject {
    var icon: UIImage?
    var name: String?
    var tweet: String?
    
    init(document: QueryDocumentSnapshot) {
        self.icon = UserDefaults.standard.object(forKey: "userImage") as? UIImage
        let Dic = document.data()
        self.name = Dic["name"] as? String
        self.tweet = Dic["tweet"] as? String
    }
    
    
}
