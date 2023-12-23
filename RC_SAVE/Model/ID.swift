//
//  ID.swift
//  RC_SAVE
//
//  Created by 酒匂竜也 on 2023/10/07.
//

import Foundation
import UIKit

//被らないようにまずは、uidを取得して7文字以降を切り捨てしかつsubStringのためString型へ変換する
let uuid = UIDevice.current.identifierForVendor!.uuidString
let id = uuid.prefix(7)
var strID = String(id)

//既に使用したIDを格納する
var userID = Set<String>()

func createID () -> String {
    var uniqueID = ""
    repeat {
        uniqueID = strID + String(Int.random(in: 0...99999999))
    } while userID.contains(uniqueID)
    userID.insert(uniqueID)
    return uniqueID
}

// 関数内でforループを実行
func generateUniqueIDs() {
    for _ in 1...10 {
        let uniqueID = createID()
    }
}
