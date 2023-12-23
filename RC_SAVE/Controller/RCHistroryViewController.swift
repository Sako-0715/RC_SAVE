//
//  RCHistroryViewController.swift
//  RC_SAVE
//
//  Created by 酒匂竜也 on 2023/10/12.
//

import UIKit
import RealmSwift
import Alamofire

class RCHistroryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var historyDataArray: [HistoryData] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.showsVerticalScrollIndicator = false
        
        Api()
        
        let refreshCnt = UIRefreshControl()
        refreshCnt.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshCnt
        } else {
            tableView.addSubview(refreshCnt)
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshData() {
        //データの再取得
        Api()
        // データを再読み込みしたら、以下のコードでリフレッシュコントロールを非表示
        tableView.refreshControl?.endRefreshing()
    }
    
    func Api() {
        //データーベースに送信する
        let url = "http://localhost:8888/iOS/Controller/ShopingHistoryController.php"
        AF.request(url).responseData { response in
            switch response.result {
            case.success(let data):
                do {
                    let decoder = JSONDecoder()
                    self.historyDataArray = try decoder.decode([HistoryData].self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("JSONデコードエラー: \(error)")
                }
            case.failure(let error):print("Error: \(error)")
                print("Error: \(error)")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let imageView = cell.contentView.viewWithTag(1) as? UIImageView
        let JanlLabel = cell.contentView.viewWithTag(2) as? UILabel
        let ProdactLabel = cell.contentView.viewWithTag(3) as? UILabel
        let PriceLabel = cell.contentView.viewWithTag(4) as? UILabel
        
        // historyDataArrayを日時の昇順でソート
        let sortedHistoryData = historyDataArray.sorted { $0.DATE > $1.DATE }
        
        // ソート済みデータから情報を取得
        let historyData = sortedHistoryData[indexPath.row]
        JanlLabel?.text = historyData.JANL
        ProdactLabel?.text = historyData.PRODACTNAME
        PriceLabel?.text = "\(historyData.PRICE)"
        
        //Realmから画像を取得する
        let realm = try! Realm()
        
        let id = historyData.ID
        let realmImage = realm.objects(ImageRealm.self).filter("ID == %@", id)
        if let historyImage = realmImage.first {
            if let image = historyImage.imageData, let img = UIImage(data: image) {
                imageView?.image = img
            } else {
                // 画像がない場合、デフォルトの画像を設定または何らかのエラー処理を行います
                imageView?.image = UIImage(named: "defaultImage")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
