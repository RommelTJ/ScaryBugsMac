//
//  MasterViewController.swift
//  ScaryBugsMac
//
//  Created by Rommel Rico on 10/16/15.
//  Copyright © 2015 Rommel Rico. All rights reserved.
//

import Cocoa

class MasterViewController: NSViewController {
    
    @IBOutlet weak var bugsTableView: NSTableView!
    @IBOutlet weak var bugTitleView: NSTextField!
    @IBOutlet weak var bugImageView: NSImageView!
    @IBOutlet weak var bugRating: EDStarRating!
    var bugs = [ScaryBugDoc]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up some sample Bugs.
        self.setupSampleBugs()
        
        //Initialize the EDStarRating
        self.bugRating.starImage = NSImage(named: "star.png")
        self.bugRating.starHighlightedImage = NSImage(named: "shockedface2_full.png")
        self.bugRating.starImage = NSImage(named: "shockedface2_empty.png")
        self.bugRating.delegate = self
        self.bugRating.maxRating = 5
        self.bugRating.horizontalMargin = 12
        self.bugRating.editable = true
        self.bugRating.displayMode = UInt(EDStarRatingDisplayFull)
        self.bugRating.rating = Float(0)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func setupSampleBugs() {
        let bug1 = ScaryBugDoc(title: "Eric Bug", rating: 4.0, thumbImage:NSImage(named: "potatoBugThumb"), fullImage: NSImage(named: "potatoBug"))
        let bug2 = ScaryBugDoc(title: "House Centipede", rating: 3.0, thumbImage: NSImage(named: "centipedeThumb"), fullImage: NSImage(named: "centipede"))
        let bug3 = ScaryBugDoc(title: "Lady Bug", rating: 5.0, thumbImage: NSImage(named: "ladybugThumb"), fullImage: NSImage(named: "ladybug"))
        let bug4 = ScaryBugDoc(title: "Wolf Spider", rating: 2.0, thumbImage: NSImage(named: "wolfSpiderThumb"), fullImage: NSImage(named: "wolfSpider"))
        bugs = [bug1, bug2, bug3, bug4]
    }
    
    func selectedBugDoc() -> ScaryBugDoc? {
        let selectedRow = self.bugsTableView.selectedRow
        if selectedRow >= 0 && selectedRow < self.bugs.count {
            return self.bugs[selectedRow]
        }
        return nil
    }
    
    func updateDetailInfo(doc: ScaryBugDoc?) {
        var title = ""
        var image: NSImage?
        var rating = 0.0
        
        if let scaryBugDoc = doc {
            title = scaryBugDoc.data.title
            image = scaryBugDoc.fullImage
            rating = scaryBugDoc.data.rating
        }
        
        self.bugTitleView.stringValue = title
        self.bugImageView.image = image
        self.bugRating.rating = Float(rating)
    }
    

}

//MARK: NSTableViewDataSource
extension MasterViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return bugs.count
    }
}

//MARK: NSTableViewDelegate
extension MasterViewController: NSTableViewDelegate {
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.identifier == "BugColumn" {
            let bugDoc = bugs[row]
            cellView.imageView?.image = bugDoc.thumbImage
            cellView.textField?.stringValue = bugDoc.data.title
            return cellView
        }
        
        return cellView
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 32
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedDoc = selectedBugDoc()
        updateDetailInfo(selectedDoc)
    }
}

//MARK: EDStarRatingProtocol
extension MasterViewController: EDStarRatingProtocol {
    
}
