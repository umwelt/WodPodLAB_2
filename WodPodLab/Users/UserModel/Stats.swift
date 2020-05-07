//
//  Stats.swift
//  WodPodLab
//
//  Created by Hugo Perez on 27/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import Foundation
import SwiftyJSON


struct Stats: Codable {
    
    enum CodingKeys: String, CodingKey {
        case challenges_completed = "challenges_completed"
        case challenges_created = "challenges_created"
        case challenges_taken = "challenges_taken"
        case challenges_won = "challenges_won"
        case programs_completed = "programs_completed"
        case programs_mastered = "programs_mastered"
        case wods_completed = "wods_completed"
        case wods_mastered = "wods_mastered"
        case level = "level"
    }
    

    
    var challenges_completed: Int = 0
    var challenges_created: Int = 0
    var challenges_taken: Int = 0
    var challenges_won: Int = 0
   
    var programs_completed: Int = 0
    var programs_mastered: Int = 0
    var wods_completed: Int = 0
    var wods_mastered: Int = 0
    
    var level: String = ""

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        challenges_completed = try container.decodeIfPresent(Int.self, forKey: .challenges_completed)!
        challenges_created = try container.decodeIfPresent(Int.self, forKey: .challenges_created)!
        challenges_taken = try container.decodeIfPresent(Int.self, forKey: .challenges_taken)!
        challenges_won = try container.decodeIfPresent(Int.self, forKey: .challenges_won)!
        
        programs_completed = try container.decodeIfPresent(Int.self, forKey: .programs_completed)!
        programs_mastered = try container.decodeIfPresent(Int.self, forKey: .programs_mastered)!
        wods_completed = try container.decodeIfPresent(Int.self, forKey: .wods_completed)!
        wods_mastered = try container.decodeIfPresent(Int.self, forKey: .wods_mastered)!
        
        level = try container.decodeIfPresent(String.self, forKey: .level)!
        
    }
    
    
    init(from json: JSON) {
        
        challenges_completed = json[CodingKeys.challenges_completed.rawValue].intValue
        challenges_created = json[CodingKeys.challenges_created.rawValue].intValue
        challenges_taken = json[CodingKeys.challenges_taken.rawValue].intValue
        challenges_won = json[CodingKeys.challenges_won.rawValue].intValue
        programs_completed = json[CodingKeys.programs_completed.rawValue].intValue
        programs_mastered = json[CodingKeys.programs_mastered.rawValue].intValue
        wods_completed = json[CodingKeys.wods_completed.rawValue].intValue
        wods_mastered = json[CodingKeys.wods_mastered.rawValue].intValue
        
        level = json[CodingKeys.level.rawValue].stringValue

        
    }
    
    
}

