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
import SDWebImage

class TweetViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var userName = String()
    var userImageString = String()
    var maxWordCount: Int = 140
    let placeholder: String = "テキストを記入..."
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.delegate = self
        tweetTextView.text = placeholder
        
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            userImageString = UserDefaults.standard.object(forKey: "userImage") as! String
        }
        
        profileImageView.sd_setImage(with: URL(string: userImageString), completed: nil)
        profileImageView.layer.cornerRadius = 40
        userNameLabel.text = userName
        
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
        
        //sendDataメソッドを使用する
        sendDBModel.sendData()
        
        //selectVCに戻る
        self.navigationController?.popViewController(animated: true)
        print("ツイートしました")
    }
    
}

extension TweetViewController: UITextViewDelegate {
    
func textView(_ tweetTextView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let existingLines = tweetTextView.text.components(separatedBy: .newlines)//既に存在する改行数
    let newLines = text.components(separatedBy: .newlines)//新規改行数
    let linesAfterChange = existingLines.count + newLines.count - 1 //最終改行数。-1は編集したら必ず1改行としてカウントされるから。
    return linesAfterChange <= 7 && tweetTextView.text.count + (text.count - range.length) <= maxWordCount
}
    
func textViewDidChange(_ tweetTextView: UITextView) {
    let existingLines = tweetTextView.text.components(separatedBy: .newlines)//既に存在する改行数
    if existingLines.count <= 7 {
        self.wordCountLabel.text = "\(maxWordCount - tweetTextView.text.count)"
    }
}
        
    func textViewDidBeginEditing(_ tweetTextView: UITextView) {
        if tweetTextView.text == placeholder {
            tweetTextView.text = nil
            tweetTextView.textColor = .darkText
        }
    }
 
    func textViewDidEndEditing(_ tweetTextView: UITextView) {
        if tweetTextView.text.isEmpty {
            tweetTextView.textColor = .darkGray
            tweetTextView.text = placeholder
        }
    }
    
}
