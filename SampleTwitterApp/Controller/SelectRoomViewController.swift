//
//  SelectRoomViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2022/01/10.
//

import UIKit
import ViewAnimator
import FirebaseAuth
import Photos
import ActiveLabel
import SDWebImage

class SelectRoomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,loadOKDelegate {
    
    
    
    var loadDBModel = LoadDBModel()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        loadDBModel.loadOKDelegate = self
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        loadDBModel.loadContents()
    }
    
    func loadOK(check: Int) {
        if check == 1{
            print("テーブルビューをリロード")
            tableView.reloadData()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isHidden = false
        
        //viewを表示する際のアニメーションの設定
        let animation = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
        UIView.animate(views: tableView.visibleCells, animations: animation,completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadDBModel.dataSets.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        
        
        //アイコン画像をセルにセット
        
        let profileImageView = cell.contentView.viewWithTag(1) as! UIImageView
        
        //SDWebImageライブラリを使用して、URLからprofileImageViewに画像をセットする
        profileImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[indexPath.row].profileImage), completed: nil)
        
        //アイコンを丸くする
        profileImageView.layer.cornerRadius = 40
        
        //ユーザー名
        let userNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        userNameLabel.text = loadDBModel.dataSets[indexPath.row].userName
        
        //ツイート
        //ハッシュタグがついているものは飛べるようにActiveLabelとして宣言
        let tweetTextLabel = cell.contentView.viewWithTag(3) as! ActiveLabel
        
        //ActiveLabelで宣言したことにより、enabledTypesを選択できる（#、＠、URL、全て）この場合はハッシュタグを選択する
        tweetTextLabel.enabledTypes = [.hashtag]
        tweetTextLabel.text = "\(loadDBModel.dataSets[indexPath.row].tweet)"
        
        
        let contentImageView = cell.contentView.viewWithTag(4) as! UIImageView
        
        contentImageView.isHidden = true
        
        if loadDBModel.dataSets[indexPath.row].contentImage != "" {
            contentImageView.isHidden = false
            contentImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[indexPath.row].contentImage), completed: nil)
        }
        
        
        //ハッシュタグがタップされた時の挙動
        tweetTextLabel.handleHashtagTap { (hashTag) in
            print(hashTag)
            
            let hashVC = self.storyboard?.instantiateViewController(withIdentifier: "hashVC") as! HashTagViewController
            hashVC.hashTag = hashTag
            self.navigationController?.pushViewController(hashVC, animated: true)
        }
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 515
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //editVCへ画面遷移
        let editVC = self.storyboard?.instantiateViewController(identifier: "editVC") as! EditViewController
        editVC.tweetID = loadDBModel.dataSets[indexPath.row].docID
        editVC.passText = loadDBModel.dataSets[indexPath.row].tweet
        editVC.passImage = loadDBModel.dataSets[indexPath.row].contentImage
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    
    @IBAction func tweet(_ sender: Any) {
        
        //tweetVCへ画面遷移
        let tweetVC = self.storyboard?.instantiateViewController(withIdentifier: "tweetVC") as! TweetViewController
        self.navigationController?.pushViewController(tweetVC, animated: true)
    }
    
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let error as NSError {
            print("エラー",error)
        }

        
        self.navigationController?.popToRootViewController(animated: true)
        print("最初に戻るよ")
        
    }
}

