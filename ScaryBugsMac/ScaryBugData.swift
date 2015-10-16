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
    
}
