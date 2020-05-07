//
//  SearchSession.swift
//  WodPodLab
//
//  Created by Hugo Perez on 23/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import Foundation
import InstantSearchClient
import PromiseKit
import SwiftyJSON

class SearchSession {
    
    static let shared = SearchSession()
    
    fileprivate var client = Client(appID: "5Z1KWZUNJL", apiKey: "3acdd8ebe3a8125e1a13928d1326a399")
    
    
    func userSearch(with searchText: String) -> Promise<[User]> {
        
        
        return Promise<[User]> { seal in
            
            let index = client.index(withName: "users_book")
            index.search(Query(query: searchText)) { (data, error) in
                
                if let _error = error {
                    seal.reject(_error)
                }
                
                if let _data = data {
                    if let hits = JSON(_data["hits"] as Any).array {
                        seal.fulfill(self.usersFromData(hits))
                    }
                }
            }
        }
        
    }
    
    fileprivate func usersFromData(_ data: [JSON]) -> [User] {
        var allUsers: [User] = []
        data.forEach({ (u) in
            allUsers.append(User(u))
        })
        
        return allUsers
    }
    
    /// Movs Search
    
    func movesSearch(with searchText: String) -> Promise<[Movement]> {
        
        
        return Promise<[Movement]> { seal in
            
            let index = client.index(withName: "movements")
            index.search(Query(query: searchText)) { (data, error) in
                
                if let _error = error {
                    seal.reject(_error)
                }
                
                if let _data = data {
                    if let hits = JSON(_data["hits"] as Any).array {
                        seal.fulfill(self.movesFromData(hits))
                    }
                }
            }
        }
        
    }
    
    func programSearch(with searchText: String) -> Promise<[Program]> {
        
        
        return Promise<[Program]> { seal in
            
            let index = client.index(withName: "programs")
            index.search(Query(query: searchText)) { (data, error) in
                
                if let _error = error {
                    seal.reject(_error)
                }
                
                if let _data = data {
                    if let hits = JSON(_data["hits"] as Any).array {
                        seal.fulfill(self.programsFromData(hits))
                    }
                }
            }
        }
        
    }
    
    fileprivate func movesFromData(_ data: [JSON]) -> [Movement] {
        var all: [Movement] = []
        data.forEach({ (u) in
            all.append(Movement(from: u))
        })
        
        return all
    }
    
    
    fileprivate func programsFromData(_ data: [JSON]) -> [Program] {
        var all: [Program] = []
        data.forEach({ (u) in
            all.append(Program(u))
        })
        
        return all
    }
    
    
}
