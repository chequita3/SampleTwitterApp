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
    @IBOutlet weak var placeHolder: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    var userName = String()
    var userImageString = String()
    var maxWordCount: Int = 140
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.delegate = self
        let checkModel = CheckModel()
        checkModel.showCheckPermission()
        
        self.wordCountLabel.text = "\(maxWordCount - tweetTextView.text.count)"
        
        sendButton.isEnabled = false
        sendButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        print("ボタンは押せません")
        
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
        
                  navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //viewをタップしたときにキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
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
                
                if contentImageView.image != nil {
                let passedData = self.contentImageView.image?.jpegData(compressionQuality: 0.01)
                let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: self.userName, tweet: self.tweetTextView.text, userImageString:self.userImageString, contentImageData: passedData!, tweetID: "")
                sendDBModel.sendHashTagWithPhoto(hashTag: hashTagText!.substring(with: match.range))
                }else{
                    let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: self.userName, tweet: self.tweetTextView.text, userImageString: self.userImageString, tweetID: "")
                    sendDBModel.sendHashTag(hashTag: hashTagText!.substring(with: match.range))
                }
            }
        }catch{
            
        }
    }
    
    
    @IBAction func addImage(_ sender: Any) {
        showAlert()
    }
    
    //編集内容をfireBaseにSendDBModelを使用して送信する
    @IBAction func send(_ sender: Any) {
        
        if contentImageView.image != nil {
            
            let passData = contentImageView.image?.jpegData(compressionQuality: 0.01)
            //ハッシュタグがついていれば、DBのハッシュタグのコレクションに保存
            searchHashTag()
            
            //sendDBModelに編集内容を渡す
            let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: userName, tweet: tweetTextView.text, userImageString: userImageString, contentImageData: passData!, tweetID: "")
            
            //sendDataWithPhotoメソッドを使用する
            sendDBModel.sendDataWithPhoto()
            
            //selectVCに戻る
            self.navigationController?.popViewController(animated: true)
            print("画像つきでツイートしました")
            
        } else {
            
            
            //ハッシュタグがついていれば、DBのハッシュタグのコレクションに保存
            searchHashTag()
            
            //sendDBModelに編集内容を渡す
            let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: userName, tweet: tweetTextView.text, userImageString: userImageString, tweetID: "")
            
            //sendDataメソッドを使用する
            sendDBModel.sendData()
            
            //selectVCに戻る
            self.navigationController?.popViewController(animated: true)
            print("ツイートしました")
        }
        
    }
    
}

//140文字制限のエクステンション
extension TweetViewController: UITextViewDelegate {
    
    //TextView内の文字数が改行数含めて140以内じゃないと文字入力できなくする
    func textView(_ tweetTextView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //既存の改行した数
        let existingLines = tweetTextView.text.components(separatedBy: .newlines)
        
        //新規改行数
        let newLines = text.components(separatedBy: .newlines)
        
        //最終的な改行数。-1は編集したら必ず1改行としてカウントされるから。
        let linesAfterChange = existingLines.count + newLines.count - 1
        
        //最終的な改行数が8以内かつ、ツイート文字数が140カウント以内であればtrueを返し、文字入力が可能になる
        return linesAfterChange <= 8 && tweetTextView.text.count + (text.count - range.length) <= maxWordCount
    }
    
    //TextViewの内容が変わるたびに実行される
    func textViewDidChange(_ tweetTextView: UITextView) {
        
        //既に存在する改行数
        let existingLines = tweetTextView.text.components(separatedBy: .newlines)
        //改行数が8以内であればwordCountLabelに文字数を反映
        if existingLines.count <= 8 {
            self.wordCountLabel.text = "\(maxWordCount - tweetTextView.text.count)"
            
            
        }
    }
    
    //文字入力を始めたら、プレースホルダーを消去
    func textViewDidBeginEditing(_ tweetTextView: UITextView) {
        self.placeHolder.isHidden = true
    }
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if tweetTextView.text.isEmpty == true{
            sendButton.isEnabled = false
            sendButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
            print("ボタンは押せません2")
        } else {
            sendButton.isEnabled = true
            sendButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
            print("ボタン使用可能")
        }
    }
    
}



extension TweetViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
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
            let Resize:CGSize = CGSize.init(width: 370, height:370)
            let resizedImage = selectedImage.resize(size: Resize)
            contentImageView.image = resizedImage
            picker.dismiss(animated: true, completion: nil)
            
        }
        
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
}








