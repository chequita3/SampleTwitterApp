//
//  HashTagViewController.swift
//  SampleTwitterApp
//
//  Created by 高山航輔 on 2022/01/11.
//

import UIKit
import SDWebImage

class HashTagViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,loadOKDelegate{
    
    
    
    var hashTag = String()
    
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var loadDBModel = LoadDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        loadDBModel.loadOKDelegate = self
        self.navigationItem.title = "#\(hashTag)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDBModel.loadHashTag(hashTag: hashTag)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func loadOK(check: Int) {
        if check == 1{
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countLabel.text = String(loadDBModel.dataSets.count)
        
        return loadDBModel.dataSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let profileImageView = cell.contentView.viewWithTag(1) as! UIImageView
        profileImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[indexPath.row].profileImage), completed: nil)
        profileImageView.layer.cornerRadius = 40
        
        
        let userNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        userNameLabel.text = loadDBModel.dataSets[indexPath.row].userName
        
        
        let tweetTextLabel = cell.contentView.viewWithTag(3) as! UILabel
        tweetTextLabel.text = "\(loadDBModel.dataSets[indexPath.row].tweet)"
        
        
        let contentImageView = cell.contentView.viewWithTag(4) as! UIImageView
        
        contentImageView.isHidden = true
        
        if loadDBModel.dataSets[indexPath.row].contentImage != "" {
            contentImageView.isHidden = false
            contentImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[indexPath.row].contentImage), completed: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        detailVC.userName = loadDBModel.dataSets[indexPath.row].userName
        detailVC.profileImageString = loadDBModel.dataSets[indexPath.row].profileImage
        detailVC.tweet = loadDBModel.dataSets[indexPath.row].tweet
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 515
        return UITableView.automaticDimension
    }
    
    
}
