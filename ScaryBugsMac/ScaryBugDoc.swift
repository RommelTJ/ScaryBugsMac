//
//  ScaryBugDoc.swift
//  ScaryBugsMac
//
//  Created by Rommel Rico on 10/16/15.
//  Copyright © 2015 Rommel Rico. All rights reserved.
//

import Cocoa

class ScaryBugDoc: NSObject {
    var data: ScaryBugData
    var thumbImage: NSImage?
    var fullImage: NSImage?
    
    override init() {
        self.data = ScaryBugData()
    }
    
    init(title: String, rating: Double, thumbImage: NSImage?, fullImage: NSImage?) {
        self.data = ScaryBugData(title: title, rating: rating)
        self.thumbImage = thumbImage
        self.fullImage = fullImage
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.data = aDecoder.decodeObjectForKey("data") as! ScaryBugData
        self.thumbImage = aDecoder.decodeObjectForKey("thumbImage") as! NSImage?
        self.fullImage = aDecoder.decodeObjectForKey("fullImage") as! NSImage?
    }
    
}

//MARK: NSCoding
extension ScaryBugDoc: NSCoding {
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.data, forKey: "data")
        aCoder.encodeObject(self.thumbImage, forKey: "thumbImage")
        aCoder.encodeObject(self.fullImage, forKey: "fullImage")
    }
}