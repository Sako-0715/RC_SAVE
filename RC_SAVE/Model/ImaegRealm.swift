//
//  ImaegRealm.swift
//  RC_SAVE
//
//  Created by 酒匂竜也 on 2023/10/08.
//

import Foundation
import RealmSwift

class ImageRealm: Object {
    @Persisted var ID: String?
    @Persisted var imageData:Data?
    @Persisted var Date:String
}
