//
//  TimeLineViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/08/08.
//

import UIKit
import Firebase
import FirebaseFirestore

struct Item {
    var icon: UIImage
    var name: String
    var tweet: String
}

class TimeLineViewController: UITableViewController {
    
//    ここにアイコン、名前、tweetの配列を入れる
    private var items: [Item] = []
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
            }
    

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //    何個のセルを生成するか？
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // itemsの配列内の要素数分を指定
            items.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath)
        tableView.rowHeight = 200
        let icon = cell.contentView.viewWithTag(1) as! UIImageView
        let name = cell.contentView.viewWithTag(2) as! UILabel
        let tweetContext = cell.contentView.viewWithTag(3) as! UILabel
//        tweetのlabelを可変にする（セルが合わせてくれる）
        tweetContext.numberOfLines = 0
        icon.image = self.items[indexPath.row].icon
        name.text = self.items[indexPath.row].name
        tweetContext.text = self.items[indexPath.row].tweet
        
        return cell
    }
    // cellがタップされたのを検知したときに実行する処理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルがタップされました！")
    }
    // セルの見積もりの高さを指定する処理
    /*override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }*/
    // セルの高さ指定をする処理
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        // UITableViewCellの高さを自動で取得する値
        return UITableView.automaticDimension
    }

    func loadData(){
//        Tweetのdocumentsを引っ張ってくる←postDateの新しい順に
//        itemsに入れる[Item]型として
        db.collection("Tweet").order(by: "postDate").addSnapshotListener { (snapShot, error) in
            
            self.items = []
            if error != nil{
                
                return
                
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let tweet = data["Tweet"] as? String{
                        
                        let itemModel = Item(icon: UserDefaults.standard.object(forKey: "userImage") as! UIImage, name: UserDefaults.standard.object(forKey: "userName") as! String, tweet: tweet)
                        self.items.append(itemModel)
                    }
                }
            }
        }
    }
    

    
//    描画するセルを指定する
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TweetTableViewCellを表示したいので、identifier:TweetTableViewCellのセルを選択。カスタムクラスのTweetTableViewCell型にキャスティングする
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell") as! TweetTableViewCell
        
        //TweetTableViewCellクラスのconfigure関数にitemsのプロパティを入れて実行
        cell.configure(item: items[indexPath.row])
//        セルを返す
        return cell
    }*/
    
}
