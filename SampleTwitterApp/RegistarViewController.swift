//
//  RegistarViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/09/12.
//

import UIKit
import Firebase

class RegistarViewController: UIViewController {
    
    


    @IBOutlet weak var registarButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView! 
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var userName: UITextField!
    
 
    @IBAction func tappedRegistarButton(_ sender: UIButton) {
        print("あい")
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = userName.text
        changeRequest?.commitChanges { error in
          // ...
        }
    }
    
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registarButton.layer.cornerRadius = 10
        userName.delegate = self
        userID.delegate = self
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
    
    


    
    
    
}

extension RegistarViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let userIDIsEmpty = userID.text?.isEmpty ?? true
        let userNameIsEmpty = userName.text?.isEmpty ?? true
        var userImageViewIsEmpty = true
        
        if userImageView == nil {
            userImageViewIsEmpty = true
        }else{
            userImageViewIsEmpty = false
        }
        if userIDIsEmpty || userNameIsEmpty || userImageViewIsEmpty {
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
