//
//  Event.swift
//  WTM
//
//  Created by Shahar Ben-Dor on 11/4/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import Foundation
import FirebaseFunctions

class Event {
    let eventId: String
    let groupId: String
    let name: String
    let location: String
    let latitude: Double
    let longitude: Double
    let description: String
    let imageCount: Int
    
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
        self.imageCount = images.count
    }
    
    static func create (groupId: String, name: String, location: String, latitude: Double, longitude: Double, description: String, images: [UIImage], completion: @escaping (Event?) -> ()) {
        AppDelegate.functions.httpsCallable("addEvent").call(["id": groupId, "name": name, "display_location": location, "latitude": latitude, "longitude": longitude, "description": description, "image_count": images.count]) { (result, error) in
            print("given id", result?.data as? [String: Any])
            if let id = (result?.data as? [String: Any])?["id"] as? String {
                let event = Event(eventId: id, groupId: groupId, name: name, location: location, latitude: latitude, longitude: longitude, description: description, images: images)
                completion(event)
                return
            }
            
            completion(nil)
        }
    }
}
