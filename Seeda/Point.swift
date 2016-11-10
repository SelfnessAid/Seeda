//
//  Point.swift
//  UPWorkApp
//
//  Created by Илья Железников on 28/04/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import UIKit

class Point: NSObject {
    var latitude: String
    var longitude: String
    var name: String
    
    init(latitude: String, longitude: String, name: String){
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        super.init()
    }
    

    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let latitude = aDecoder.decodeObjectForKey("latitude") as? String,
        let longitude = aDecoder.decodeObjectForKey("longitude") as? String,
        let name = aDecoder.decodeObjectForKey("name") as? String
            else { return nil }
        self.init(
        latitude: latitude,
        longitude: longitude,
        name: name
        )
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(latitude, forKey:"latitude")
        aCoder.encodeObject(longitude, forKey:"longitude")
        aCoder.encodeObject(name, forKey:"name")
    }
}


