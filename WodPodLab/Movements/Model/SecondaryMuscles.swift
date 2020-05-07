//
//  SecondaryMuscles.swift
//  WodPodLab
//
//  Created by Hugo Perez on 29/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//



import Foundation
import SwiftyJSON
import RealmSwift

@objcMembers
class SecondaryMuscles: Object {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let name = "name"
    }
    
    // MARK: Properties
    dynamic var name: String! = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    convenience required init(json: JSON) {
        self.init()
         if json["name"] != JSON.null {
                   
                   let test = json["name"].stringValue
                   
//                   print("testitem: \(test)")
                   
                   name = test
               } else {
                   let test = json.stringValue
//                   print("testitem: \(test)")
                   name = test
               }
               
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[SerializationKeys.name] = name.capitalized
        return dictionary
    }
    
    
}
