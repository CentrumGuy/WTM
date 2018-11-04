//
//  Group.swift
//  WTM
//
//  Created by Shahar Ben-Dor on 11/4/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import Foundation
import FirebaseFunctions

class Group {
    let groupId: String!
    let name: String!
    
    init (groupId: String, name: String) {
        self.groupId = groupId
        self.name = name
    }
    
    static func create(name: String, completion: @escaping (Group?) -> ()) {
        if AppDelegate.currentUser == nil {
            completion(nil)
            return
        }
        
        AppDelegate.functions.httpsCallable("createGroup").call(["name": name, "username": AppDelegate.currentUser?.name]) { (result, error) in
            if let id = (result?.data as? [String: Any])?["id"] as? String {
                let group = Group(groupId: id, name: name)
                completion(group)
                return
            }
            
            completion(nil)
        }
    }
    
    func join(completion: @escaping (HTTPSCallableResult?, Error?) -> ()) {
        AppDelegate.functions.httpsCallable("joinGroup").call(["id": groupId]) { (result, error) in
            completion(result, error)
        }
    }
}
