//
//  TimeLineViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2021/08/08.
//

import UIKit

class TimeLineViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    // テーブル表示用のデータソース
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        // dataSourceの指定を自分自身(self = TimelineViewController)に設定
        tableView.dataSource = self
        // ダミーデータの生成
        let user = User(id: "1", screenName: "ktanaka117", name: "ダンボー田中", profileImageURL: "https://pbs.twimg.com/profile_images/832034247414206464/PCKoQRPD.jpg")
        let tweet = Tweet(id: "01", text: "Twitterクライアント作成なう", user: user)

        let tweets = [tweet]
        self.tweets = tweets

        // tableViewのリロード
        tableView.reloadData()
        

            }
    
        }
extension TimeLineViewController: UITableViewDelegate {
    // cellがタップされたのを検知したときに実行する処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルがタップされました！")
    }
    // セルの見積もりの高さを指定する処理
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    // セルの高さ指定をする処理
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // UITableViewCellの高さを自動で取得する値
        return UITableView.automaticDimension
    }
}

extension TimeLineViewController: UITableViewDataSource {
    
//    何個のセルを生成するか？
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // tweetsの配列内の要素数分を指定
        return tweets.count
    }
    
//    描画するセルを指定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TweetTableViewCellを表示したいので、TweetTableViewCellを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell") as! TweetTableViewCell
        
        // TweetTableViewCellの描画内容となるtweetを渡す
        cell.fill(tweet: tweets[indexPath.row])
        
        return cell
    }
    
}
