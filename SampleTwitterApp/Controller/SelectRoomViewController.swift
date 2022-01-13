//
//  SelectRoomViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2022/01/10.
//

import UIKit
import ViewAnimator
import Photos
import ActiveLabel
import SDWebImage

class SelectRoomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,loadOKDelegate {

    
    
    var loadDBModel = LoadDBModel()
    //var roomArray = ["今日の1枚","爆笑報告場(草)","景色が好き！","夜景写真軍団","今日のごはん"]
    
    //var imageArray = ["0","1","2","3","4"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        loadDBModel.loadOKDelegate = self
        // Do any additional setup after loading the view.
    }
    
    func loadOK(check: Int) {
        if check == 1{
            print("ロード完了、セルを表示します")
            tableView.reloadData()
        }
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 756
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        //tableView.isHidden = true
        loadDBModel.loadContents()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //tableView.isHidden = false
        
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
        tableView.rowHeight = 200

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
        
        tableView.estimatedRowHeight = 211
        return UITableView.automaticDimension
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTweet = loadDBModel.dataSets[indexPath.row].tweet
        //editVCへ画面遷移
        let editVC = self.storyboard?.instantiateViewController(identifier: "editVC") as! EditViewController
        editVC.roomNumber = indexPath.row
        editVC.passText = selectedTweet
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    
    @IBAction func tweet(_ sender: Any) {
        
        //tweetVCへ画面遷移
        let tweetVC = self.storyboard?.instantiateViewController(withIdentifier: "tweetVC") as! TweetViewController
        self.navigationController?.pushViewController(tweetVC, animated: true)
    }
}
