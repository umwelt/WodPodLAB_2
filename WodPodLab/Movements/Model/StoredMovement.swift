//
//  StoredMovement.swift
//  WodPodLab
//
//  Created by Hugo Perez on 29/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

@objcMembers
class StoredMovement: Object {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        
        static let id = "id"
        static let displayName = "display_name"
        static let descriptionValue = "description"
        static let primaryMuscles = "primary_muscles"
        static let secondaryMuscles = "secondary_muscles"
        static let videoURL = "video_url"
        static let doubleWeight = "double_weight"
        static let doubleSided = "double_sided"
        static let equipment = "equipment"
        static let cardio = "cardio"
        static let time = "time"
        static let weight = "weight"
        static let adv = "adv"
        static let difficulty = "met"
        static let mean = "mean"
        static let reps = "reps"
        static let distance = "distance"
        static let partial = "partial"
        static let met = "met"
        static let isRecord = "isRecord"
        static let pauseLength = "pause_length"
        static let pauseType = "pause_type"
        static let interval = "interval"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    // MARK: Properties
    dynamic var id: String!
    dynamic var displayName: String = ""
    var primaryMuscles = List<PrimaryMuscles>()
    var secondaryMuscles = List<SecondaryMuscles>()
    dynamic var videoURL: String = ""
    dynamic var doubleWeight: Bool = false
    dynamic var doubleSided: Bool = false
    dynamic var weight: Bool = false
    dynamic var equipment: String = ""
    dynamic var cardio: Bool = false
    dynamic var time: Int = 0
    dynamic var adv: Bool = false
    dynamic var difficulty: Double = 0
    dynamic var mean: Double = 0
    dynamic var partial: Double = 0
    dynamic var reps: Int = 0
    dynamic var distance: Bool = false
    dynamic var met: Double = 0
    dynamic var isRecord: Bool = false
    dynamic var pauseLength: Int = 0
    dynamic var pauseType: String = ""
    dynamic var interval: Int = 0
    
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    convenience required init(json: JSON, movementId: String) {
        self.init()
        
        
        
        id = movementId
        displayName = json["display_name"].stringValue
        distance = json["distance"].boolValue
        videoURL = json["video_url"].stringValue
        
        let _primaryMuscles = json["primary_muscles"].arrayValue
        
        _ = _primaryMuscles.map { muscle in
            
            primaryMuscles.append(PrimaryMuscles(json:muscle))
        }
        
        
        let _secondaryMuscles = json["secondary_muscles"].arrayValue
        
        _ = _secondaryMuscles.map { muscle in
            
            secondaryMuscles.append(SecondaryMuscles(json: muscle))
        }
        
        self.equipment = json[SerializationKeys.equipment].stringValue
        
        
        doubleWeight = json["double_weight"].boolValue
        doubleSided = json["double_sided"].boolValue
        weight = json["weight"].boolValue
        time = json["time"].intValue
        cardio = json["cardio"].boolValue
        adv = json["adv"].boolValue
        difficulty = json["difficulty"].doubleValue
        mean = json["mean"].doubleValue
        partial = json["partial"].doubleValue
        reps = json["reps"].intValue
        met = json["met"].doubleValue
        isRecord = json["isRecord"].boolValue
        pauseLength = json[SerializationKeys.pauseLength].intValue
        pauseType = json[SerializationKeys.pauseType].stringValue
        interval = json[SerializationKeys.interval].intValue
        
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        
        dictionary["primary_muscles"] = Array(primaryMuscles).map { $0.dictionaryRepresentation() }
        dictionary["secondary_muscles"] = Array(secondaryMuscles).map { $0.dictionaryRepresentation() }
        dictionary["display_name"] = displayName
        dictionary["id"] = id
        dictionary["double_weight"] = doubleWeight
        dictionary["double_sided"] = doubleSided
        dictionary["weight"] = weight
        dictionary["video_url"] = videoURL
        dictionary["cardio"] = cardio
        dictionary["adv"] = adv
        dictionary["reps"] = reps
        dictionary["partial"] = partial
        dictionary["distance"] = distance
        dictionary["met"] = met
        dictionary["mean"] = mean
        dictionary["pauseLength"] = pauseLength
        dictionary["pauseType"] = pauseType
        dictionary["interval"] = interval
        dictionary[SerializationKeys.equipment] = equipment
        
        return dictionary
    }
    
    
    static func add(with movement: StoredMovement, in realm: Realm = Realm.safeInit()!) {
        
        do {
            try realm.write {
                realm.add(movement, update: .all)
            }
        } catch let error {
            print(error)
        }
        
    }
    
    static func all(in realm: Realm = Realm.safeInit()!) -> [StoredMovement] {
        return Array(realm.objects(StoredMovement.self).filter("videoURL != %@", "").sorted(byKeyPath: "displayName", ascending: true))
    }
    
    static func searchable(in realm: Realm = Realm.safeInit()!) -> Results<StoredMovement> {
        return realm.objects(StoredMovement.self).filter("videoURL != %@", "").sorted(byKeyPath: "displayName", ascending: true)
    }
    
    static func cardio(in realm: Realm = Realm.safeInit()!) -> [StoredMovement] {
        return Array(realm.objects(StoredMovement.self).filter("cardio == %@", false))
    }
    
    
    static func staticPredicate(term: String, cardio: String, adv: String) -> NSPredicate {
        return NSPredicate(format: "ANY SELF.primaryMuscles.name == '\(term)'")
    }
    
    static func booleanPredicate(term: String, cardio: String, adv: String) -> NSPredicate {
        
        /// cardio AND  adv parameters contain equality operators ==  OR  !=
        
        if cardio.isEmpty && !adv.isEmpty {
            return NSPredicate(format: "SELF.adv \(adv) %d", true)
        } else if !cardio.isEmpty && adv.isEmpty {
            return NSPredicate(format: "SELF.cardio \(cardio) %d", true)
        } else { /// Both are filled
            return NSPredicate(format: "SELF.adv \(adv) %d AND SELF.cardio \(cardio) %d", true, true)
        }
        
    }
    
    static func staticExclusionPredicate(term: String, cardio: String, adv: String) -> NSPredicate {
        return NSPredicate(format: "NONE SELF.primaryMuscles.name == '\(term)' AND NONE SELF.secondaryMuscles.name == '\(term)'")
    }
    
    
    static func byFilter(with included: [String], excluded: [String], cardio: String, adv: String, in realm: Realm = Realm.safeInit()!) -> [StoredMovement] {
        
        var subpredicates: Set<NSPredicate> = Set()
        
    
        included.forEach { (term) in
            if term == "Cardio" || term == "Advanced" {
                subpredicates.insert(booleanPredicate(term: term, cardio: cardio, adv: adv))
            } else {
                subpredicates.insert(staticPredicate(term:term, cardio:cardio, adv:adv))
            }
        }
        
        excluded.forEach { (term) in
            if term == "Cardio" || term == "Advanced" {
                subpredicates.insert(booleanPredicate(term: term, cardio: cardio, adv: adv))
            } else {
                subpredicates.insert(staticExclusionPredicate(term: term, cardio: cardio, adv: adv))
            }
            
        }
        
        subpredicates.insert(andHaveVideo())
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: Array(subpredicates))
        
        print(compound)
        
        return Array(realm.objects(StoredMovement.self).filter(compound).sorted(byKeyPath: "displayName", ascending: true))
        
    }
    
    
    static func byFilterAndTerm(term: String, with included: [String], excluded: [String], cardio: String, adv: String, in realm: Realm = Realm.safeInit()!) -> [StoredMovement] {
        
        var subpredicates: Set<NSPredicate> = Set()

    
        included.forEach { (term) in
            if term == "Cardio" || term == "Advanced" {
                subpredicates.insert(booleanPredicate(term: term, cardio: cardio, adv: adv))
            } else {
                subpredicates.insert(staticPredicate(term:term, cardio:cardio, adv:adv))
            }
        }
        
        excluded.forEach { (term) in
            if term == "Cardio" || term == "Advanced" {
                subpredicates.insert(booleanPredicate(term: term, cardio: cardio, adv: adv))
            } else {
                subpredicates.insert(staticExclusionPredicate(term: term, cardio: cardio, adv: adv))
            }
            
        }
        
        subpredicates.insert(andHaveVideo())
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: Array(subpredicates))
        
        return Array(realm.objects(StoredMovement.self).filter(compound).filter(forDisplayName(term)).sorted(byKeyPath: "displayName", ascending: true))
        
    }
    
    
    static func search(with term: String, in realm: Realm = Realm.safeInit()!) -> Results<StoredMovement> {

        return realm
            .objects(StoredMovement.self)
            .filter(forDisplayName(term))
            .filter(andHaveVideo())
            .sorted(byKeyPath: "displayName", ascending: true)
    }
    
    
    // MARK: - Predicates for search
    
    static func forDisplayName(_ name: String) -> NSCompoundPredicate {
        
        let start = NSPredicate(format: "displayName LIKE[c] '\(name)*'")
        let mid = NSPredicate(format: "displayName LIKE[c] '*\(name)*'")
        let end = NSPredicate(format: "displayName LIKE[c] '*\(name)'")
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: [start, mid, end])
    }
    
    /// Will return only thos movements that contain the URL of a Video
    static func andHaveVideo() -> NSPredicate {
        return NSPredicate(format: "videoURL != %@", "")
    }
    
    /// DS - Double sided
    static func stringForDS(set: Sets) -> String {
        return  "\(set.reps) REPS (\(set.reps) right + \(set.reps) left)".uppercased()
    }
    
    func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
    static func byId(in realm: Realm = Realm.safeInit()!, id: String) -> StoredMovement? {
        return realm.object(ofType: StoredMovement.self, forPrimaryKey: id)
    }
    
    
    static func movByDisplayName(in realm: Realm = Realm.safeInit()!, displayName: String) -> StoredMovement? {
        guard let _sets = realm.objects(StoredMovement.self).filter("displayName == %@", displayName).first else {
            return nil
        }
        return _sets
    }

    

    
    
    
}
