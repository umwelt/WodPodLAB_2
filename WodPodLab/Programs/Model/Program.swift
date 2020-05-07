//
//  Program.swift
//  WodPodLab
//
//  Created by Hugo Perez on 27/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//


import Foundation
import SwiftyJSON

struct Program: Encodable {

    var order: Int = 0
    var author: Author = Author(JSON.null)
    var tagLine: String = ""
    var active: Bool = false
    var images: String?
    var name: String = ""
    var pDescription: String = ""
    var type: String = ""
    var id: String!
    var objectID: String!
    var wods: [Wod] = []
    var price: Int = 0
    var t_days: [String] = []
    var difficulty: String = ""
    var main_goals: String = ""
    var secondary_goals: String = ""
    var tags: [String] = []
    var wod_instructions: String = ""
    var main_category: String = ""

    init(_ json: JSON) {
        order = json["order"].intValue
        author = Author(json["author"])
        tagLine = json["tag_line"].stringValue
        active = json["active"].boolValue
        images = json["images"].stringValue
        name = json["name"].stringValue
        pDescription = json["p_description"].stringValue
        type = json["type"].stringValue
        id = json["id"].stringValue
        objectID = self.id
        wods = json["wods"].arrayValue.map { Wod($0) }
        price = json["price"].intValue
        t_days = json["t_days"].arrayValue.map({ $0.stringValue })
        difficulty = json["difficulty"].stringValue
        main_goals = json["main_goals"].stringValue
        secondary_goals = json["secondary_goals"].stringValue
        tags = json["tags"].arrayValue.map({ $0.stringValue })
        wod_instructions = json["wod_instructions"].stringValue
        main_category = json["main_category"].stringValue
    }

}


extension Program {
    
    struct AUTHORS {
        static let WODPOD_LAB = "WodPod LAB"
    }
    
    struct _modeType {
        static let FITNESS_TEST: String = "FITNESS_TEST"
        static let PERFORMANCE: String = "PERFORMANCE"
        static let INTERVAL: String = "INTERVAL"
        static let WEIGHT: String = "WEIGHT"
    }
    
    struct FitnessGoals {
        static let FAT_LOSS: String = "FAT LOSS"
        static let STRENGHT: String = "STRENGHT"
        static let FLEXIBILITY: String = "FLEXIBILITY"
        static let MUSCLE_GAIN: String = "MUSCLE GAIN"
        static let CONDITIONING: String = "CONDITIONING"
        static let PERFORMANCE: String = "PERFORMANCE"
        
    }
    
    struct MainCategories {
        static let LOSE_FAT = "LOSE FAT AND TONE UP"
        static let GAIN_MUSCLE = "GAIN MUSCLE AND STRENGHT"
        static let GET_IN_SHAPE = "GET IN SHAPE SUPER FAST"
        static let TRAINING_SERIES = "TRAINING SERIES"
        static let BEGINNERS = "BEGINNERS'S ROUTINES"
        static let TABATA = "TABATA TRAINING"
        static let ROOKIE_TO_HERO = "ROOKIE TO HERO CHALLENGES"
    }
    
    static func mainCategories() -> [String] {
        return [ self.MainCategories.LOSE_FAT,
                 self.MainCategories.GAIN_MUSCLE,
                 self.MainCategories.GET_IN_SHAPE,
                 self.MainCategories.TRAINING_SERIES,
                 self.MainCategories.BEGINNERS,
                 self.MainCategories.TABATA,
                 self.MainCategories.ROOKIE_TO_HERO
        ]
    }

    static func fitnessGoals() -> [String] {
        return [ self.FitnessGoals.FAT_LOSS,
                 self.FitnessGoals.STRENGHT,
                 self.FitnessGoals.FLEXIBILITY,
                 self.FitnessGoals.MUSCLE_GAIN,
                 self.FitnessGoals.CONDITIONING,
                 self.FitnessGoals.PERFORMANCE]
    }
    
    
 
    
}
