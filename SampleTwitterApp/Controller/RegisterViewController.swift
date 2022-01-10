//
//  RegisterViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2022/01/10.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var urlString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //カメラ許可画面を出す
        let checkModel = CheckModel()
        checkModel.showCheckPermission()

    }
    
    @IBAction func register(_ sender: Any) {
        
        //SelectRoomVCへ画面遷移
        let selectVC = self.storyboard?.instantiateViewController(withIdentifier: "selectVC") as! SelectRoomViewController
        
        //ユーザーネームをアプリ内に保存
        UserDefaults.standard.setValue(self.textField.text, forKey: "userName")
        
        //画像を圧縮
        let data = self.profileImageView.image?.jpegData(compressionQuality: 0.01)
        
        //dataをSendDBModelのsendProfileImageDataメソッドを使用して、firebaseStorageへ保存
        let sendDBModel = SendDBModel()
        sendDBModel.sendProfileImageData(data: data!)
        
        self.navigationController?.pushViewController(selectVC, animated: true)
    }
    
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
                profileImageView.image = selectedImage
                picker.dismiss(animated: true, completion: nil)
                
            }
            
        }
    
    //imageViewをタップした時の挙動
    @IBAction func tapImageView(_ sender: Any) {
        
        //震える動作を追加
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        //下記のカメラかアルバムを選択するようアラートを表示する
        showAlert()
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
     
    //画面をタップした時、キーボードを閉じる
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         
         textField.resignFirstResponder()
         
     }
}
