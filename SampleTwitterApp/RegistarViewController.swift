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
    let user = Auth.auth().currentUser
    
    @IBAction func tappedRegistarButton(_ sender: UIButton) {
        uploadImage ()
        uploadName ()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registarButton.layer.cornerRadius = 10
        userName.delegate = self

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func selectPicture(_ sender: Any) {
    // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
    func uploadImage () {
        if let user = user {
            //ストレージサーバのURLを取得
            let storage = Storage.storage().reference(forURL: "gs://sampletwitterapp-2a133.appspot.com")
            
            // パス: あなた固有のURL/profileImage/{user.uid}.jpeg
            let imageRef = storage.child("profileImage").child("\(user.uid).jpeg")
            
            //保存したい画像のデータを変数として持つ
            var ProfileImageData: Data = Data()
            
            //プロフィール画像が存在すれば
            if userImageView.image != nil {
                
            //画像を圧縮
            ProfileImageData = (userImageView.image?.jpegData(compressionQuality: 0.01))!
                
            }
            
            //storageに画像を送信
            imageRef.putData(ProfileImageData, metadata: nil) { (metaData, error) in
                
                //エラーであれば
                if error != nil {
                    
                    print(error.debugDescription)
                    return  //これより下にはいかないreturn
                }
            }
        }
    }
    
    func uploadName () {
        if let user = user{
            let db = Firestore.firestore()
            guard let name = self.userName.text else { return }

            db.collection("users").document(user.uid).setData(["name" : name])
}
}
}

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


extension RegistarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        let image = info[.originalImage] as! UIImage
        // ビューに表示する
        userImageView.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
}
