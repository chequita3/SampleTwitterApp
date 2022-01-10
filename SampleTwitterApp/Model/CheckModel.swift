//
//  CheckModel.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2022/01/10.
//

import Foundation
import Photos

class CheckModel {
    
    func showCheckPermission(){
           PHPhotoLibrary.requestAuthorization { (status) in
               
               switch(status){
                   
               case .authorized:
                   print("許可されてますよ")

               case .denied:
                       print("拒否")

               case .notDetermined:
                           print("notDetermined")
                   
               case .restricted:
                           print("restricted")
                   
               case .limited:
                   print("limited")
               @unknown default: break
                   
               }
               
           }
       }
}
