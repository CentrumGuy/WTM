//
//  Event.swift
//  WTM
//
//  Created by Shahar Ben-Dor on 11/4/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import Foundation
import FirebaseFunctions
import FirebaseDatabase

class Event {
    let eventId: String
    let groupId: String
    let name: String
    let location: String
    let latitude: Double
    let longitude: Double
    let description: String
    
    var images: [UIImage]?
    
    init (eventId: String, groupId: String, name: String, location: String, latitude: Double, longitude: Double, description: String, images: [UIImage]) {
        self.eventId = eventId
        self.groupId = groupId
        self.name = name
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.images = images
    }
    
    static func create (groupId: String, name: String, location: String, latitude: Double, longitude: Double, description: String, images: [UIImage], completion: @escaping (Event?) -> ()) {
        AppDelegate.functions.httpsCallable("addEvent").call(["id": groupId, "name": name, "display_location": location, "latitude": latitude, "longitude": longitude, "description": description, "image_count": images.count]) { (result, error) in
            print("given id", result?.data as? [String: Any])
            
            if let id = (result?.data as? [String: Any])?["id"] as? String {
                let event = Event(eventId: id, groupId: groupId, name: name, location: location, latitude: latitude, longitude: longitude, description: description, images: images)
                
                let group = DispatchGroup()
                group.enter()
                var count = 0
                for i in 0..<images.count {
                    let jpegData = images[i].jpegData(compressionQuality: 0.5)!
                    AppDelegate.storage.reference().child("groups").child(groupId).child("events").child(id).child("\(i)").putData(jpegData, metadata: nil, completion: { (metadata, error) in
                        count += 1
                        
                        if count >= images.count {
                            group.leave()
                        }
                        
                    })
                }
                
                group.notify(queue: DispatchQueue.main, execute: {
                    completion(event)
                })
                return
            }
            
            completion(nil)
        }
    }
    
    func load(groupId: String, eventId: String, snapshot: DataSnapshot, completion: @escaping (Event?) -> ()) {
        if !snapshot.hasChild(eventId) {
            completion(nil)
            return
        }
        
        let snap = snapshot.childSnapshot(forPath: eventId)
        let name = snap.childSnapshot(forPath: "name").value as! String
        let location = snap.childSnapshot(forPath: "display_location").value as! String
        let latitude = snap.childSnapshot(forPath: "latitude").value as! Double
        let longitude = snap.childSnapshot(forPath: "longitude").value as! Double
        let description = snap.childSnapshot(forPath: "description").value as! String
        let targetPhotos = snap.childSnapshot(forPath: "image_count").value as! Int
        
        let group = DispatchGroup()
        group.enter()
        var images = [UIImage]()
        for i in 0..<targetPhotos {
            AppDelegate.storage.reference().child("groups").child(groupId).child("events").child(eventId).child("photos").child("\(i)").downloadURL { (url, error) in
                UIImage.load(url: url!, completion: { (image) in
                    images.append(image!)
                    if images.count >= targetPhotos {
                        group.leave()
                    }
                })
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            let event = Event(eventId: eventId, groupId: groupId, name: name, location: location, latitude: latitude, longitude: longitude, description: description, images: images)
            completion(event)
        }
    }
}
