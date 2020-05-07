//
//  Sets.swift
//
//  Created by Hugo Perez on 29/04/2020
//  Copyright (c) . All rights reserved.
//


import Foundation
import SwiftyJSON

struct Sets: Encodable {

    var id: String = ""
    var movementId: String = ""
    var reps: Int = 1
    var interval: Int = 0
    var pause_length: Int = 0

    init(_ json: JSON) {
        id = json["id"].stringValue
        movementId = json["movement_id"].stringValue
        reps = json["reps"].intValue
        interval = json["interval"].intValue
        pause_length = json["pause_length"].intValue
    }

}
