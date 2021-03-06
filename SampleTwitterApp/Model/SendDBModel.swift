//
//  SendDBModel.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2022/01/10.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore

class SendDBModel {
    
    var userID = String()
    var userName = String()
    var tweet = String()
    var userImageString = String()
    var contentImageData = Data()
    var tweetID = String()
    var db = Firestore.firestore()
    
    init() {
        
    }
    
    init(userID:String,userName:String,tweet:String,userImageString:String,contentImageData:Data,tweetID:String) {

        self.userID = userID
        self.userName = userName
        self.tweet = tweet
        self.userImageString = userImageString
        self.contentImageData = contentImageData
        self.tweetID = tweetID
        
    }
    
    init(userID:String,userName:String,tweet:String,userImageString:String,tweetID:String) {
        
        self.userID = userID
        self.userName = userName
        self.tweet = tweet
        self.userImageString = userImageString
        self.tweetID = tweetID
        
    }
    

    func sendDataWithPhoto() {
        
        //storageへの参照を作成（分かりやすいようにIDと日時を入れる）
        let imageRef = Storage.storage().reference().child("Images").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        //storageへ保存する
        imageRef.putData(contentImageData, metadata: nil) { [self] (metadata, error) in
            if error != nil{
                print("storageへの保存に失敗")
                return
            }
            print("storageへの保存に成功しました")
            
            //保存に成功した場合、ダウンロード用のURLを受け取る
            imageRef.downloadURL {(url, error) in
                if error != nil{
                    print("ダウンロードURLの取得に失敗しました")
                    return
                }
                print("ダウンロードURLの取得に成功しました")
                
                
                
                self.db.collection("tweet").document().setData(["userID" : self.userID as Any,"userName" : self.userName as Any,"tweet" : self.tweet as Any,"userImageString" : self.userImageString as Any,"contentImage": url?.absoluteString as Any,"postDate" : Date().timeIntervalSince1970])
            }
        }
    }
    
    func sendData() {

                self.db.collection("tweet").document().setData(["userID" : self.userID as Any,"userName" : self.userName as Any,"tweet" : self.tweet as Any,"userImageString" : self.userImageString as Any,"contentImage": String(""),"postDate" : Date().timeIntervalSince1970])
            }
  
    
    func sendProfileImageData(data:Data) {
        
        //RegisterViewControllerから渡ってきたData型のdataをUIImage型に変換
        let image = UIImage(data: data)
        
        //UIImage型のimageをData型にして圧縮
        let profileImage = image?.jpegData(compressionQuality: 0.1)
        
        //storageへの参照を作成（分かりやすいようにIDと日時を入れる）
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        //storageへ保存する
        imageRef.putData(profileImage!, metadata: nil) { (metadata, error) in
            if error != nil{
                print("storageへの保存に失敗しました")
                return
            }
            print("storageへの保存に成功しました")
            
            //保存に成功した場合、ダウンロード用のURLを受け取る
            imageRef.downloadURL {(url, error) in
                if error != nil{
                    print("ダウンロードURLの取得に失敗しました")
                    return
                }
                print("ダウンロードURLの取得に成功しました")
                
                //ダウンロード用URLをString型にキャストして、アプリ内に保存する
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
            }
        }
    }
    
    
    
    func sendHashTagWithPhoto(hashTag:String){
        
        //storageへの参照を作成（分かりやすいようにIDと日時を入れる）
        let imageRef = Storage.storage().reference().child(hashTag).child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        //storageへ保存する
        imageRef.putData(contentImageData, metadata: nil) { (metadata, error) in
            if error != nil{
                print("storageへの保存に失敗しました")
                return
            }
            print("storageへの保存に成功しました")
            
            //保存に成功した場合、ダウンロード用のURLを受け取る
            imageRef.downloadURL {(url, error) in
                if error != nil{
                    print("ダウンロードURLの取得に失敗しました")
                    return
                }
                print("ダウンロードURLの取得に成功しました")
                
                self.db.collection(hashTag).document().setData(["userID" : self.userID as Any,"userName" : self.userName as Any,"tweet" : self.tweet as Any,"userImageString" : self.userImageString as Any,"contentImage": url?.absoluteString as Any,"postDate" : Date().timeIntervalSince1970])
                
                
            }
        }
        
    }
    
    func sendHashTag(hashTag:String){
        
        self.db.collection(hashTag).document().setData(["userID" : self.userID as Any,"userName" : self.userName as Any,"tweet" : self.tweet as Any,"userImageString" : self.userImageString as Any,"contentImage": "", "postDate" : Date().timeIntervalSince1970])
    }
    
    
    func sendEditedData() {

        self.db.collection("tweet").document("\(self.tweetID)").setData(["userID" : self.userID as Any,"userName" : self.userName as Any,"tweet" : self.tweet as Any,"userImageString" : self.userImageString as Any,"contentImage": String(""),"postDate" : Date().timeIntervalSince1970])
            }
    
    func sendEditedDataWithPhoto() {
        
        //storageへの参照を作成（分かりやすいようにIDと日時を入れる）
        let imageRef = Storage.storage().reference().child("Images").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        //storageへ保存する
        imageRef.putData(contentImageData, metadata: nil) { [self] (metadata, error) in
            if error != nil{
                print("storageへの保存に失敗")
                return
            }
            print("storageへの保存に成功しました")
            
            //保存に成功した場合、ダウンロード用のURLを受け取る
            imageRef.downloadURL {(url, error) in
                if error != nil{
                    print("ダウンロードURLの取得に失敗しました")
                    return
                }
                print("ダウンロードURLの取得に成功しました")
                
                
                
                self.db.collection("tweet").document("\(self.tweetID)").setData(["userID" : self.userID as Any,"userName" : self.userName as Any,"tweet" : self.tweet as Any,"userImageString" : self.userImageString as Any,"contentImage": url?.absoluteString as Any,"postDate" : Date().timeIntervalSince1970])
            }
        }
    }

}


