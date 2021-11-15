//
//  TimeLineViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/08/08.
//

import UIKit
import Firebase
import FirebaseFirestore



class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //    ここにアイコン、名前、tweetの配列を入れる
    var items: [Item] = []
    var db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        print("\(items)")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //    何個のセルを生成するか？
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // itemsの配列内の要素数分を指定
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    // セルの高さ指定をする処理
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
                        
                        let itemModel = Item(icon: UserDefaults.standard.object(forKey: "userImage") as! UIImage, name: UserDefaults.standard.object(forKey: "userName") as! String, tweet: tweet,docID: doc.documentID)
                        self.items.append(itemModel)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
}
