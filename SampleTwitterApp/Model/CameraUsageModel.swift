//
//  CameraUsageModel.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/10/30.
//


import Foundation
import Photos

class CameraUsageModel{
    
    
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
