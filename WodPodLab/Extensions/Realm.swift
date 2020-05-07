//
//  Realm.swift
//  WodPodLab
//
//  Created by Hugo Perez on 30/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    static func safeInit() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        }
        catch {
            // LOG ERROR
        }
        return nil
    }

    func safeWrite(_ block: () -> ()) {
        do {
            // Async safety, to prevent "Realm already in a write transaction" Exceptions
            if !isInWriteTransaction {
                try write(block)
            }
        } catch {
            // LOG ERROR
        }
    }
}
