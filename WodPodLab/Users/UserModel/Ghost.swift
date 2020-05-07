//
//  Ghost.swift
//  WodPodLab
//
//  Created by Hugo Perez on 24/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//


import Foundation
import SwiftyJSON


struct Ghost: Codable {
    
    enum CodingKeys: String, CodingKey {
        case allReps = "allReps"
        case displayName = "displayName"
        case id = "id"
        case interval = "interval"
        case mean = "mean"
        case partial = "partial"
    }
    
    var allReps: Int = 0
    var displayName: String = ""
    var id: String!
    var interval: Double = 0.0
    var mean: Double = 0.0
    var partial: Double = 0.0

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        allReps = try container.decodeIfPresent(Int.self, forKey: .allReps)!
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)!
        id = try container.decodeIfPresent(String.self, forKey: .id)
        interval = try container.decodeIfPresent(Double.self, forKey: .interval)!
        mean = try container.decodeIfPresent(Double.self, forKey: .mean)!
        partial = try container.decodeIfPresent(Double.self, forKey: .partial)!
        
    }
    
    
    init(from json: JSON) {
        
        allReps = json[CodingKeys.allReps.rawValue].intValue
        displayName = json[CodingKeys.displayName.rawValue].stringValue
        id = json[CodingKeys.id.rawValue].stringValue
        interval = json[CodingKeys.interval.rawValue].doubleValue
        mean = json[CodingKeys.mean.rawValue].doubleValue
        partial = json[CodingKeys.partial.rawValue].doubleValue

        
    }
    
    
}

