//
//  SendDBModel.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/10/30.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class SendDBModel{
    
    init() {}
    
    func uploadImage(data: Data){
        let image = UIImage(data: data)
        let imageData = image!.jpegData(compressionQuality: 0.1)
        let user = Auth.auth().currentUser
        if let user = user{
            let ID = user.uid
            let uploadRef = Storage.storage().reference(withPath: "profileImage/\(ID).jpg")
            uploadRef.putData(imageData!, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error!!")
                    return
                }
                print("completed")
                
            }
        }
    }

    
}
