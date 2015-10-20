//
//  ScaryBugData.swift
//  ScaryBugsMac
//
//  Created by Rommel Rico on 10/16/15.
//  Copyright © 2015 Rommel Rico. All rights reserved.
//

import Cocoa

class ScaryBugData: NSObject {
    var title: String
    var rating: Double

    override init() {
        self.title = String()
        self.rating = 0
    }
    
    init(title: String, rating: Double) {
        self.title = title
        self.rating = rating
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.rating = aDecoder.decodeObjectForKey("rating") as! Double
    }
}

//MARK: NSCoding
extension ScaryBugData: NSCoding {
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(Double(self.rating), forKey: "rating")
    }
}