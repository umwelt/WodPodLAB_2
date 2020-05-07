//
//  Wod.swift
//
//  Created by Hugo Perez on 29/04/2020
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Wod: Encodable {

    var info: Info = Info(JSON.null)
    var id: String = ""
    var program: Bool = true
    var programId: String = ""
    var wodType: String = ""
    var intentedProgram: String = ""
    var sets: [Sets] = []

    init(_ json: JSON) {
        info = Info(json["info"])
        id = json["id"].stringValue
        program = json["program"].boolValue
        programId = json["programId"].stringValue
        wodType = json["wod_type"].stringValue
        intentedProgram = json["intented_program"].stringValue
        sets = json["sets"].arrayValue.map { Sets($0) }
    }

}
