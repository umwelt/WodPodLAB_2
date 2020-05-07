//
//  Movement.swift
//  WodPodLab
//
//  Created by Hugo Perez on 23/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import Foundation
import SwiftyJSON


struct Movement: Codable {
    
    enum CodingKeys: String, CodingKey {
        case distance = "distance"
        case secondaryMuscles = "secondary_muscles"
        case weight = "weight"
        case objectID = "objectID"
        case time = "time"
        case equipment = "equipment"
        case doubleWeight = "double_weight"
        case videoUrl = "video_url"
        case id = "id"
        case doubleSided = "double_sided"
        case met = "met"
        case adv = "adv"
        case cardio = "cardio"
        case primaryMuscles = "primary_muscles"
        case displayName = "display_name"
        case reps = "reps"
    }
    
    var distance: String?
    var secondaryMuscles: [String]?
    var weight: String?
    var objectID: String?
    var time: String?
    var equipment: String?
    var doubleWeight: String?
    var videoUrl: String?
    var id: String?
    var doubleSided: String?
    var met: String?
    var adv: String?
    var cardio: String?
    var primaryMuscles: [String]?
    var displayName: String!
    var reps: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        distance = try container.decodeIfPresent(String.self, forKey: .distance)
        secondaryMuscles = try container.decodeIfPresent([String].self, forKey: .secondaryMuscles)
        weight = try container.decodeIfPresent(String.self, forKey: .weight)
        objectID = try container.decodeIfPresent(String.self, forKey: .objectID)
        time = try container.decodeIfPresent(String.self, forKey: .time)
        equipment = try container.decodeIfPresent(String.self, forKey: .equipment)
        doubleWeight = try container.decodeIfPresent(String.self, forKey: .doubleWeight)
        videoUrl = try container.decodeIfPresent(String.self, forKey: .videoUrl)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        doubleSided = try container.decodeIfPresent(String.self, forKey: .doubleSided)
        met = try container.decodeIfPresent(String.self, forKey: .met)
        adv = try container.decodeIfPresent(String.self, forKey: .adv)
        cardio = try container.decodeIfPresent(String.self, forKey: .cardio)
        primaryMuscles = try container.decodeIfPresent([String].self, forKey: .primaryMuscles)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        reps = try container.decodeIfPresent(String.self, forKey: .reps)
    }
    
    
    init(from json: JSON) {
        
        distance = json[CodingKeys.distance.rawValue].stringValue
        secondaryMuscles = json[CodingKeys.secondaryMuscles.rawValue].arrayValue.compactMap({ $0.stringValue })
        weight = json[CodingKeys.weight.rawValue].stringValue
        objectID = json[CodingKeys.objectID.rawValue].stringValue
        time = json[CodingKeys.time.rawValue].stringValue
        equipment = json[CodingKeys.equipment.rawValue].stringValue
        doubleWeight = json[CodingKeys.doubleWeight.rawValue].stringValue
        videoUrl = json[CodingKeys.videoUrl.rawValue].stringValue
        id = json[CodingKeys.objectID.rawValue].stringValue
        doubleSided = json[CodingKeys.doubleSided.rawValue].stringValue
        met = json[CodingKeys.met.rawValue].stringValue
        adv = json[CodingKeys.adv.rawValue].stringValue
        cardio = json[CodingKeys.cardio.rawValue].stringValue
        primaryMuscles = json[CodingKeys.primaryMuscles.rawValue].arrayValue.compactMap({ $0.stringValue })
        displayName = json[CodingKeys.displayName.rawValue].stringValue
        reps = json[CodingKeys.reps.rawValue].stringValue
        
    }
    
    
}
