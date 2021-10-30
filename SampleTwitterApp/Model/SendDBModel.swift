//
//  SendDBModel.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/10/30.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreMedia

class SendDBModel{
    
    init(){
        
    }

    
    func sendProfileImageData(data:Data){
        
        let image = UIImage(data: data)
        let profileImage = image!.jpegData(compressionQuality: 0.1)
        
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(profileImage!, metadata: nil) { (metadata, error) in
            
            if error != nil{
                
                return
            }
            
            imageRef.downloadURL { (url, error) in
                
                if error != nil{
                    
                    return
                }
                
                UserDefaults.standard.set(url?.absoluteString, forKey: "userImage")
            }
        }
        
        
        
    }

}
