//
//  BaseRequestAPI.swift
//  RC_SAVE
//
//  Created by 酒匂竜也 on 2024/01/26.
//

import Foundation
import Alamofire

class BaseRequestAPIModel {
    func postShoppingData(id: String, janl: String, price: String, prodact: String, date: String, completion: @escaping (Result<String, Error>) -> Void) {
        // データーベースに送信する
        let url = "http://localhost:8888/KeepFood/iOS/Controller/ShopingController.php"
        
        let shopdata: [String: Any] = ["ID": id, "Janl": janl, "Price": price, "Prodact": prodact, "date": date]
        
        AF.request(url, method: .post, parameters: shopdata, encoding: URLEncoding.default)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let resultString = String(data: data, encoding: .utf8) {
                        completion(.success(resultString))
                    } else {
                        completion(.failure(NSError(domain: "ResponseError", code: 0, userInfo: nil)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
