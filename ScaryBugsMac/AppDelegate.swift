//
//  AppDelegate.swift
//  ScaryBugsMac
//
//  Created by Rommel Rico on 10/16/15.
//  Copyright © 2015 Rommel Rico. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var masterViewController = MasterViewController()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        masterViewController.setupSampleBugs()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

