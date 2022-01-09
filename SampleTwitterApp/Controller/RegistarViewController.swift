//
//  RegistarViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/09/12.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore


class RegistarViewController: UIViewController {
    
    @IBOutlet weak var registarButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UITextField!
    
    var urlString = String()
    var sendDBModel = SendDBModel()
    
    let user = Auth.auth().currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        カメラの使用許可を出す
        let cameraUsageModel = CameraUsageModel()
        cameraUsageModel.showCheckPermission()
        
        //        登録ボタンの角を丸くする
        registarButton.layer.cornerRadius = 10
        
    }
    
    
    
    @IBAction func tappedRegistarButton(_ sender: UIButton) {
        
        self.uploadName()
        //        ユーザー名をアプリに保存
        UserDefaults.standard.set(self.userName.text, forKey: "userName")
        
        //        ユーザー画像をdata型として100分の1に圧縮
        let data = self.userImageView.image?.jpegData(compressionQuality: 0.01)
        
        //        sendDBModelのメソッドを利用して画像データをfireStorageに送る
        self.sendDBModel.uploadImage(data: data!)
        

//                   タイムラインビューへ画面遷移する
            self.performSegue(withIdentifier: "toTimeLineVC", sender: self)
//        ツイートビューへ画面遷移
//        self.performSegue(withIdentifier: "toTweetVC", sender: self)
    }
    
    
    
    @IBAction func tapUserImageView(_ sender: Any) {
        
//        画像をタップした際にバイブさせる
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        showAlert()
    }
    
    
    
    func uploadName () {
        if let user = user{
            let db = Firestore.firestore()
            guard let name = self.userName.text else { return }
            
            db.collection("users").document(user.uid).setData(["name" : name])
        }
    }
}


//ユーザーの名前と画像が設定されていないと、登録ボタンを押せなくするエクステンション
extension RegistarViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let userNameIsEmpty = userName.text?.isEmpty ?? true
        var userImageViewIsEmpty = true
        
        if userImageView == nil {
            userImageViewIsEmpty = true
        }else{
            userImageViewIsEmpty = false
        }
        if userNameIsEmpty || userImageViewIsEmpty {
            registarButton.isEnabled = false
        }else{
            registarButton.isEnabled = true
        }
    }
}

//カメラを使用するエクステンション
extension RegistarViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func doCamera(){
        
        let sourceType:UIImagePickerController.SourceType = .camera
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    
    func doAlbum(){
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if info[.originalImage] as? UIImage != nil{
            
            let selectedImage = info[.originalImage] as! UIImage
            userImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         
         picker.dismiss(animated: true, completion: nil)
         
     }
     
     
     //アラート
     func showAlert(){
         
         let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
         
         let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
             
             self.doCamera()
             
         }
         let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
             
             self.doAlbum()
             
         }

         let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
         
         
         alertController.addAction(action1)
         alertController.addAction(action2)
         alertController.addAction(action3)
         self.present(alertController, animated: true, completion: nil)
         
     }
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         
         userName.resignFirstResponder()
         
     }
}

