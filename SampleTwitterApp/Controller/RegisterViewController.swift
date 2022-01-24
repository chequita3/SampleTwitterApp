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
    @IBOutlet weak var registerButton: UIButton!
    
    var urlString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //カメラ許可画面を出す
        let checkModel = CheckModel()
        checkModel.showCheckPermission()
        
        //キーボードが出現した時にshowKeyboadメソッドをNotificationCenterのエントリーに加える
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboad), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //キーボードが出現した時にhideKeyboadメソッドをNotificationCenterのエントリーに加える
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboad), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //キーボードが出現した時のメソッド。ボタンとテキストビューの位置を調整する
    @objc func showKeyboad(notification:NSNotification) {
        print("キーボード出たよ")
        let keyboadFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboadMiniY = keyboadFrame?.minY else { return }
        let sendButtonMaxY = registerButton.frame.maxY
        let distance = sendButtonMaxY - keyboadMiniY + 20
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {self.view.transform = transform}, completion: nil)
    }
    
    //キーボードが隠れた時のメソッド。動いたビューの位置を元に戻す
    @objc func hideKeyboad(notification:NSNotification){
        print("キーボード隠れたよ")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {self.view.transform = .identity}, completion: nil)
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
    
    //キーボードのreturnキーをタップするとキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
}
