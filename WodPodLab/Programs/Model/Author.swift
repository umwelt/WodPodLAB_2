//
//  Author.swift
//  WodPodLab
//
//  Created by Hugo Perez on 29/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//


import Foundation
import SwiftyJSON

struct Author: Encodable {

    var name: String = "WODPOD LAB"

    init(_ json: JSON) {
        name = json["name"].stringValue
    }

}
