//
//  TimeLineViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/08/08.
//

import UIKit

struct Item {
    var icon: UIImage
    var name: String
    var tweet: String
}

class TimeLineViewController: UITableViewController {
    
//    ここにアイコン、名前、tweetの配列を入れる
    private let items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
            }
    
        
    // cellがタップされたのを検知したときに実行する処理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルがタップされました！")
    }
    // セルの見積もりの高さを指定する処理
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    // セルの高さ指定をする処理
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // UITableViewCellの高さを自動で取得する値
        return UITableView.automaticDimension
    }


    
//    何個のセルを生成するか？
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // tweetsの配列内の要素数分を指定
        items.count
    }
    
//    描画するセルを指定する
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TweetTableViewCellを表示したいので、TweetTableViewCellを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell") as! TweetTableViewCell
        
        // TweetTableViewCellの描画内容となるtweetを渡す
        cell.configure(item: items[indexPath.row])
        return cell
    }
    
}
