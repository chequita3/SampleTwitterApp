//
//  LoadDBModel.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2022/01/10.
//

import Foundation
import Firebase

class LoadDBModel{
    
    var dataSets = [DataSet]()
    let db = Firestore.firestore()
    
    func loadContents() {
        
        db.collection("tweet").order(by: "postDate").addSnapshotListener {(snapShot, error) in
            
            if error != nil{
                print("データの受信に失敗しました")
                return
            }
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let userID = data["userID"] as? String,let userName = data["userName"] as? String,let tweet = data["tweet"] as? String,let profileImage = data["userImageString"] as? String,let postDate = data["postDate"] as? Double{
                        
                        let newDataSet = DataSet(userID: userID, userName: userName, tweet: tweet, profileImage: profileImage, postDate: postDate)
                        
                        self.dataSets.append(newDataSet)
                        self.dataSets.reverse()
                        print("データの表示に成功しました")
                    }
                }
            }
        }
    }
}
