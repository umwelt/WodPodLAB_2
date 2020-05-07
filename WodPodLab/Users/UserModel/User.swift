//
//  User.swift
//  WodPodLab
//
//  Created by Hugo Perez on 23/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import Foundation
import SwiftyJSON


class User: NSObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case objectID
        case id
        case email
        case name
        case username
        case last_name
        case photoURL
        case fitcoins
        
    }
    
    enum ExpressionKeys: String {
        case objectID
        case id
        case email
        case name
        case username
        case last_name
        case photoURL
        case fitcoins
    }
    
    @objc var objectID: String
    @objc var id: String
    @objc var email: String
    @objc var name: String
    @objc var username: String
    @objc var last_name: String
    @objc var photoURL: String
    @objc var fitcoins: Int
    
    
    // MARK: - Initializers
    
    init(objectID: String, id: String, email: String, name: String, username: String, last_name: String, photoURL: String, fitcoins: Int) {
        self.objectID = objectID
        self.id = id
        self.email = email
        self.name = name
        self.username = username
        self.last_name = last_name
        self.photoURL = photoURL
        self.fitcoins = fitcoins
    }
    
    init(_ json: JSON) {
        objectID = json[CodingKeys.objectID.rawValue].stringValue
        id = json[CodingKeys.id.rawValue].stringValue
        email = json[CodingKeys.email.rawValue].stringValue
        name = json[CodingKeys.name.rawValue].stringValue
        username = json[CodingKeys.username.rawValue].stringValue
        last_name = json[CodingKeys.last_name.rawValue].stringValue
        photoURL = json[CodingKeys.photoURL.rawValue].stringValue
        fitcoins = json[CodingKeys.fitcoins.rawValue].intValue
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectID = try container.decode(String.self, forKey: .objectID)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        name = try container.decode(String.self, forKey: .name)
        username = try container.decode(String.self, forKey: .username)
        last_name = try container.decode(String.self, forKey: .last_name)
        photoURL = try container.decode(String.self, forKey: .photoURL)
        fitcoins =  try container.decode(Int.self, forKey: .fitcoins)
        
    }
    
  
    // MARK: - Encoding
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(objectID, forKey: .objectID)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(username, forKey: .username)
        try container.encode(last_name, forKey: .last_name)
        try container.encode(photoURL, forKey: .photoURL)
        try container.encode(fitcoins, forKey: .fitcoins)
        
    }
    
    
}
