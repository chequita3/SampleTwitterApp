//
//  TweetViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2022/01/10.
//

import UIKit
import Firebase
import FirebaseAuth
import PKHUD

class TweetViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var userName = String()
    var userImageString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            userImageString = UserDefaults.standard.object(forKey: "userImage") as! String
        }

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
           
           tweetTextView.resignFirstResponder()
           return true
           
       }
    
    func searchHashTag(){

     let hashTagText = tweetTextView.text as NSString?
            do{
                let regex = try NSRegularExpression(pattern: "#\\S+", options: [])
                for match in regex.matches(in: hashTagText! as String, options: [], range: NSRange(location: 0, length: hashTagText!.length)) {


                    let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: self.userName, tweet: self.tweetTextView.text, userImageString:self.userImageString)
                    sendDBModel.sendHashTag(hashTag: hashTagText!.substring(with: match.range))
                }
            }catch{
                
            }
    }
    
    //編集内容をfireBaseにSendDBModelを使用して送信する
    @IBAction func send(_ sender: Any) {
        
        if tweetTextView.text.isEmpty == true{
            print("ツイートテキストに何も書いていません")
            return
        }
        
        //ハッシュタグがついていれば、DBのハッシュタグのコレクションに保存
        searchHashTag()
        
        //sendDBModelに編集内容を渡す
        let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: userName, tweet: tweetTextView.text, userImageString: userImageString)
        
        //sendDataメソッドにroomNumberを渡して使用する
        sendDBModel.sendData()
        
        //selectVCに戻る
        self.navigationController?.popViewController(animated: true)
    }
    
}
