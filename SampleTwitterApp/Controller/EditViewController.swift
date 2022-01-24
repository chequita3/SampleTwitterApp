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
    
    var tweetID = String()
    var passText = String()
    var passImage = String()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var imageChangeButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    
    var userName = String()
    var userImageString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.text = passText
        if passImage != "" {
            contentImageView.sd_setImage(with: URL(string: passImage), completed: nil)
        }

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
        //        let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: userName, tweet: tweetTextView.text, userImageString: userImageString, contentImageData: <#String#>)
        
        //sendDataメソッドにroomNumberを渡して使用する
        //        sendDBModel.sendData(roomNumber: String(roomNumber))
        //        sendDBModel.sendData()
        //selectVCに戻る
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
