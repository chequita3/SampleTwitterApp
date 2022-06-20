//
//  LoadDBModel.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2022/01/10.
//

import Foundation
import Firebase

protocol loadOKDelegate {
    
    func loadOK(check:Int)
}

class LoadDBModel{
    
    var dataSets = [DataSet]()
    let db = Firestore.firestore()
    
    var loadOKDelegate:loadOKDelegate?
    
    func loadContents() {
        
        db.collection("tweet").order(by: "postDate", descending: true).addSnapshotListener {(snapShot, error) in
            
            self.dataSets = []
            
            if error != nil{
                print("データの受信に失敗しました")
                return
            }
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    
                    
                    
                    let data = doc.data()
                    if let userID = data["userID"] as? String,let userName = data["userName"] as? String,let tweet = data["tweet"] as? String,let profileImage = data["userImageString"] as? String,let contentImage = data["contentImage"]as? String,let postDate = data["postDate"] as? Double{
                        
                        let newDataSet = DataSet(docID: doc.documentID, userID: userID, userName: userName, tweet: tweet, profileImage: profileImage, contentImage: contentImage, postDate: postDate)
                        
                        self.dataSets.append(newDataSet)
                        self.loadOKDelegate?.loadOK(check: 1)
                        print("データを受信しました")
                    }
                }
            }
        }
    }
    
    
    func loadHashTag(hashTag:String){
            //addSnapShotListnerは値が更新される度に自動で呼ばれる
            db.collection("#\(hashTag)").order(by:"postDate", descending: true).addSnapshotListener { (snapShot, error) in
                
                self.dataSets = []
                
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                if let snapShotDoc = snapShot?.documents{
       
                    for doc in snapShotDoc{
                        let data = doc.data()
                        if let userID = data["userID"] as? String,let userName = data["userName"] as? String,let tweet = data["tweet"] as? String,let profileImage = data["userImageString"] as? String,let contentImage = data["contentImage"]as? String,let postDate = data["postDate"] as? Double{
                            
                            let newDataSet = DataSet(docID: doc.documentID, userID: userID, userName: userName, tweet: tweet, profileImage: profileImage, contentImage: contentImage, postDate: postDate)
                            
                            self.dataSets.append(newDataSet)
                            self.loadOKDelegate?.loadOK(check: 1)
                            

                        }
                        
                        
                    }
                    
                }

                
            }
            
            
        }
    
}
