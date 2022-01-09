//
//  TimeLineViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/08/08.
//

import UIKit
import Firebase
import FirebaseFirestore

struct Contents {
    var icon: UIImage
    var name: String
    var tweet: String
}

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var db = Firestore.firestore()
    let user = Auth.auth().currentUser
    //    ここにアイコン、名前、tweetの配列を入れる
    var contents: [Contents] = [Contents(icon: UIImage(systemName: "sun.min")!,
                                         name: "name",
                              tweet: "tweet")]

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
        self.getDoc()
        self.tableView.reloadData()
    }
 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //    何個のセルを生成するか？
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // itemsの配列内の要素数分を指定
        self.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        cell.configure(contents: contents[indexPath.row])
        tableView.rowHeight = 200
        return cell
    }
    
    // セルの高さ指定をする処理
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        // UITableViewCellの高さを自動で取得する値
        return UITableView.automaticDimension
    }
    
    func loadData(){
        let tweetRef = self.db.collection("tweet")
        
        
            tweetRef.document(self.user!.uid).setData([
            
            "tweet" : "asobo" as String,
            "postDate" : Timestamp(date: Date())]
        )
    }
    
        func getDoc(){
            db.collection("tweet").getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")

                }else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        
                    }
                }
            }
        }
        

}
