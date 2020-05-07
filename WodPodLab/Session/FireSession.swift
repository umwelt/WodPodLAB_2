//
//  FireSession.swift
//  WodPodLab
//
//  Created by Hugo Perez on 22/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import Foundation
import PromiseKit
import Firebase
import SwiftyJSON
import CodableFirebase



class FireSession {
    
    
    static let shared = FireSession()
    
    lazy var functions = Functions.functions()
    
    private let db = Firestore.firestore()
    
    
    /// Only admin users can access this application
    func userLogin(username: String, password: String) -> Promise<Bool> {
        
        return Promise<Bool> { seal in
            
            Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
                
                if let _error = error {
                    seal.reject(_error)
                }
                
                if result != nil {
                    seal.fulfill(true)
                }
                
            }
        }
    }
    
    
    /// User Search
    func searchUser(_ userdata: String) -> Promise<[JSON]> {
        
        
        return Promise<[JSON]> { seal in
            functions.httpsCallable("user_search")
                .call(
                    [ "string": userdata  ], completion: { (result, error) in
                        if let error = error {
                            seal.reject(error)
                        } else {
                            if let _result = result {
                                if let _data = JSON(_result.data).dictionaryObject {
                                    if let _users = _data["data"] {
                                        seal.fulfill(JSON(_users).arrayValue)
                                    }
                                    
                                }
                                
                            }
                        }
                })
        }
        
    }
    
    
    /// User Search
    func indexMovements(_ userdata: String) {
        
        functions.httpsCallable("index_movements")
            .call(
                [ "string": "" ], completion: { (result, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if let _result = result {
                            if let _data = JSON(_result.data).dictionaryObject {
                                print(_data["data"] as Any)
                            }
                            
                        }
                    }
            })
        
        
    }
    
    /// Update Movement
    
    /// User Search
    func mov_update(_ movement: Movement, update: Bool = true) -> Promise<Bool> {
        
        
        return Promise<Bool> { seal in
            functions.httpsCallable("mov_update")
                .call(
                    [ "data": self.encoded(movement), "update": true], completion: { (result, error) in
                        if let error = error {
                            seal.reject(error)
                        } else {
                            if result != nil {
                                seal.fulfill(true)
                            }
                        }
                })
        }
        
    }
    
    
    /// User Search
    func mov_remove(_ movement: Movement) -> Promise<Bool> {
        
        
        return Promise<Bool> { seal in
            functions.httpsCallable("mov_remove")
                .call(
                    [ "data": self.encoded(movement)], completion: { (result, error) in
                        if let error = error {
                            seal.reject(error)
                        } else {
                            if result != nil {
                                seal.fulfill(true)
                            }
                        }
                })
        }
        
    }
    
    
    func getGhostData(for userId: String) -> Promise<[Ghost]> {
        return Promise<[Ghost]> { seal in
            
            
            self.db.collection("users").document(userId).collection("ghost").getDocuments { (snapshot, error) in
                
                if let _error = error {
                    seal.reject(_error)
                }
                
                if let _snapshot = snapshot {
                    var allGhost: [Ghost] = []
                    _snapshot.documents.forEach { (document) in
                        allGhost.append(Ghost(from: JSON(document.data())))
                    }
                    seal.fulfill(allGhost)
                }
            }
        }
    }
    
    func getUserProfileData(for userId: String) -> Promise<User> {
        return Promise<User> { seal in
            
            
            self.db.collection("users").document(userId).collection("profile").document(userId).getDocument { (snapshot, error) in
                
                if let _error = error {
                    seal.reject(_error)
                }
                
                if let _snapshot = snapshot {
                    seal.fulfill(User(JSON(_snapshot.data() as Any)))
                }
                
            }
        }
    }
    
    func getStatsData(for userId: String) -> Promise<Stats> {
        
        return Promise<Stats> { seal in
            
            self.db.collection("users").document(userId).collection("stats").document(userId).getDocument { (snapshot, error) in
                
                if let _error = error {
                    seal.reject(_error)
                }
                
                if let _snapshot = snapshot {
                    seal.fulfill(Stats(from: JSON(_snapshot.data() as Any)))
                }
            }
        }
    }
    
    /// Get Program
    func getProgramData(for programId: String) -> Promise<Program> {
        
        return Promise<Program> { seal in
            
            self.db.collection("market").document(programId).getDocument { (snapshot, error) in
                
                if let _error = error {
                    seal.reject(_error)
                }
                
                if let _snapshot = snapshot {
                    if let _data = _snapshot.data() {
                         seal.fulfill(Program(JSON(_data)))
                    } else {
                        seal.reject(DataError.EMPTY)
                    }
                   
                }
            }
        }
    }
    
    
    /// Save Program
    
    func saveProgram(with program: Program) -> Promise<Bool> {
        
        return Promise<Bool> { seal in
            
            self.db.collection("market").addDocument(data: self.programData(program)) { (error) in
                if let _error = error {
                    seal.reject(_error)
                }
                seal.fulfill(true)
                
            }
            
        }
        
    }
    
    fileprivate func programData(_ program: Program) -> [String: Any] {
        
        return try! FirestoreEncoder().encode(program)
        
//        let _program = [
//            "order": 0,
//            "author": [
//                "name": program.author.name
//            ],
//            "tag_line": program.tagLine,
//            "active": "\(program.active)",
//            "images": program.images ?? "",
//            "name": program.name,
//            "description": program.pDescription,
//            "type": program.type,
//            "id": program.id ?? "",
//            "objectID": program.id ?? "",
//            "wods": program.wods ?? [],
//            "price": program.price,
//            "t_days": program.t_days ?? [],
//            "difficulty": program.difficulty,
//            "main_goals": program.main_goals,
//            "secondary_goals": program.secondary_goals,
//            "tags": program.tags ?? [],
//            "wod_instructions": program.wod_instructions,
//            "main_category": program.main_category
//            ] as [String : Any]
//
//        return
        
    }
    
    /// Get all movements data
    
    func getAllMovements() {
        
        self.db.collection("movements").getDocuments { (snapshot, error) in
            if let _error = error {
                Messages.shared.showError(_error.localizedDescription)
            }
            
            if let _snap = snapshot {
                DispatchQueue.main.async {
                    for doc in _snap.documents {
                        StoredMovement.add(with: StoredMovement(json:  JSON(doc.data()), movementId: doc.documentID))
                    }
                }
                
            }
            
            
            
        }
        
    }
    
    
    fileprivate func encoded(_ data: Movement) -> [String: Any] {
        
        
        
        return [
            "primary_muscles": data.primaryMuscles ?? [],
            "distance": data.distance ?? "false",
            "id": data.id ?? "",
            "double_weight": data.doubleWeight ?? "false",
            "reps": data.reps ?? "false",
            "secondary_muscles": data.secondaryMuscles ?? [],
            "adv": data.adv ?? "false",
            "cardio": data.cardio ?? "false",
            "double_sided": data.doubleSided ?? "false",
            "equipment": data.equipment ?? "",
            "time": data.time ?? "false",
            "met": data.met ?? "0.0",
            "weight": data.weight ?? "false",
            "video_url": data.videoUrl ?? "",
            "display_name": data.displayName ?? "",
            "objectID": data.id ?? ""
        ]
        
        
        
    }
    
    
    
}
