//
//  EditViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2022/01/10.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

class EditViewController: UIViewController {
    
    var roomNumber = Int()
    var passText = String()

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var userName = String()
    var userImageString = String()
    let screenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.text = passText
//        //キーボードが出てきた時にkeyboardWillShowメソッドを呼ぶ
//        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        //キーボードが隠れた時にkeyboardWillHideメソッドを呼ぶ
//        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
//
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            userImageString = UserDefaults.standard.object(forKey: "userImage") as! String
        }
        
        profileImageView.sd_setImage(with: URL(string: userImageString), completed: nil)
        profileImageView.layer.cornerRadius = 40
        userNameLabel.text = userName
        tweetTextView.text = passText
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           navigationController?.setNavigationBarHidden(true, animated: true)
           
       }

       //キーボードが出てきた時に呼ばれるメソッド
    //tweetTextViewとsendButtonの位置を上げる
//       @objc func keyboardWillShow(_ notification:NSNotification){
//
//              let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
//
//           tweetTextView.frame.origin.y = screenSize.height - keyboardHeight - tweetTextView.frame.height
//              sendButton.frame.origin.y = screenSize.height - keyboardHeight - sendButton.frame.height
//
//
//          }

    //キーボードが隠れた時に呼ばれるメソッド
    //tweetTextViewとsendButtonの位置を下げる
//       @objc func keyboardWillHide(_ notification:NSNotification){
//           tweetTextView.frame.origin.y = screenSize.height - tweetTextView.frame.height
//           sendButton.frame.origin.y = screenSize.height - sendButton.frame.height
//           
//           //キーボードを隠す際のアニメーションの設定
//           guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
//               
//           UIView.animate(withDuration: duration) {
//                  let transform = CGAffineTransform(translationX: 0, y: 0)
//                  self.view.transform = transform
//              }
//       }
       
    //viewをタップしたときにキーボードを閉じる
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           
           tweetTextView.resignFirstResponder()
           
       }
       
    //キーボードのreturnキーをタップするとキーボードを閉じる
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           
           textField.resignFirstResponder()
           return true
           
       }
    
    //編集内容をfireBaseにSendDBModelを使用して送信する
    @IBAction func send(_ sender: Any) {
        
        if tweetTextView.text.isEmpty == true{
            print("ツイートテキストに何も書いていません")
            return
        }
        
        //sendDBModelに編集内容を渡す
        let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: userName, tweet: tweetTextView.text, userImageString: userImageString, contentImageString: <#String#>)
        
        //sendDataメソッドにroomNumberを渡して使用する
//        sendDBModel.sendData(roomNumber: String(roomNumber))
        sendDBModel.sendData()
        //selectVCに戻る
        self.navigationController?.popViewController(animated: true)
    }
    

}
