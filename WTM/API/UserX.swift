//
//  UserX.swift
//  WTM
//
//  Created by Shahar Ben-Dor on 11/4/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import Foundation
import Firebase

class UserX {
    let uid: String
    let email: String
    let name: String
    
    init (uid: String, email: String, name: String) {
        self.uid = uid
        self.email = email
        self.name = name
    }
    
    static func create(email: String, password: String, name: String, completion: ((AuthDataResult?) -> ())? = nil) {
        AppDelegate.auth.createUser(withEmail: email, password: password) { (result, error) in
            if let result = result {
                let user = result.user
                let uid = user.uid
                AppDelegate.database.reference().child("users").child(uid).child("name").setValue(name, withCompletionBlock: { (error, reference) in
                    if error != nil {
                        print(error!)
                    }
                    
                    UserDefaults.standard.set(name, forKey: "name")
                    completion?(result)
                })
                
                return
            }
            
            completion?(result)
        }
    }
    
    static func get(completion: @escaping (UserX?) -> ()) {
        if let user = AppDelegate.auth.currentUser {
            AppDelegate.database.reference().child(user.uid).observe(.value) { (snapshot) in
                if let name = snapshot.childSnapshot(forPath: "name").value as? String {
                    let toReturn = UserX(uid: user.uid, email: user.email!, name: name)
                    completion(toReturn)
                    return
                }
                
                completion(nil)
            }
            
            return
        }
        
        completion(nil)
    }
}
