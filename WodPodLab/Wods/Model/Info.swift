//
//  Info.swift
//
//  Created by Hugo Perez on 29/04/2020
//  Copyright (c) . All rights reserved.
//


import Foundation
import SwiftyJSON

struct Info: Encodable {

    var name: String = ""
    var rounds: Int = 1
    var wodPhotoURL: String = ""
    var isFitTest: Bool = false

    init(_ json: JSON) {
        name = json["name"].stringValue
        rounds = json["rounds"].intValue
        wodPhotoURL = json["wodPhotoURL"].stringValue
        isFitTest = json["isFitTest"].boolValue
    }

}
