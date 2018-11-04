//
//  Group.swift
//  WTM
//
//  Created by Shahar Ben-Dor on 11/4/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import Foundation
import FirebaseFunctions
import FirebaseStorage

class Group {
    let groupId: String!
    let name: String!
    let groupImage: UIImage?
    
    init (groupId: String, name: String, image: UIImage?) {
        self.groupId = groupId
        self.name = name
        self.groupImage = image
    }
    
    static func create(name: String, image: UIImage?, completion: @escaping (Group?) -> ()) {
        if AppDelegate.currentUser == nil {
            completion(nil)
            return
        }
        
        AppDelegate.functions.httpsCallable("createGroup").call(["name": name, "username": AppDelegate.currentUser?.name]) { (result, error) in
            if let id = (result?.data as? [String: Any])?["id"] as? String {
                let group = Group(groupId: id, name: name, image: image)
                
                if let image = image {
                    let jpeg = image.jpegData(compressionQuality: 0.5)!
                    AppDelegate.storage.reference().child("groups").child(id).child("image").putData(jpeg, metadata: nil, completion: { (metadata, error) in
                        completion(group)
                    })
                    
                    return
                }
                
                completion(group)
                return
            }
            
            completion(nil)
        }
    }
    
    static func join(groupId: Group, completion: @escaping (HTTPSCallableResult?, Error?) -> ()) {
        AppDelegate.functions.httpsCallable("joinGroup").call(["id": groupId]) { (result, error) in
            completion(result, error)
        }
    }
    
    func get(id: String, completion: @escaping (Group?) -> ()) {
        AppDelegate.database.reference().child("groups").child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let name = snapshot.childSnapshot(forPath: "name").value as? String {
                AppDelegate.storage.reference().child("groups").child(id).child("image").downloadURL { (url, error) in
                    var toReturn = Group(groupId: id, name: name, image: nil)
                    if let url = url {
                        UIImage.load(url: url, completion: { (image) in
                            toReturn = Group(groupId: id, name: name, image: image)
                        })
                    }
                    
                    completion(toReturn)
                }
                
                return
            }
            
            completion(nil)
        }
    }
}
