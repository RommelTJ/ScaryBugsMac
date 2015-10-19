//
//  MasterViewController.swift
//  ScaryBugsMac
//
//  Created by Rommel Rico on 10/16/15.
//  Copyright © 2015 Rommel Rico. All rights reserved.
//

import Cocoa
import Quartz

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
    
    func reloadSelectedBugRow() {
        let indexSet = NSIndexSet(index: self.bugsTableView.selectedRow)
        let columnSet = NSIndexSet(index: 0)
        self.bugsTableView.reloadDataForRowIndexes(indexSet, columnIndexes: columnSet)
    }

}

//MARK: IBActions 
extension MasterViewController {
    @IBAction func deleteBug(sender: AnyObject) {
        //Get selected Doc
        if let _ = selectedBugDoc() {
            //Remove the bug from the model.
            self.bugs.removeAtIndex(self.bugsTableView.selectedRow)
            //Remove the selected row from the table view.
            self.bugsTableView.removeRowsAtIndexes(NSIndexSet(index: self.bugsTableView.selectedRow), withAnimation: NSTableViewAnimationOptions.SlideRight)
            //Clear the detail info.
            updateDetailInfo(nil)
        }
    }
    
    @IBAction func addBug(sender: AnyObject) {
        //Create a new ScaryBugDoc object with a default name.
        let newDoc = ScaryBugDoc(title: "New Bug", rating: 0.0, thumbImage: nil, fullImage: nil)
        //Add the new bug object to our model.
        self.bugs.append(newDoc)
        let newRowIndex = self.bugs.count - 1
        //Insert new row in the table view.
        self.bugsTableView.insertRowsAtIndexes(NSIndexSet(index: newRowIndex), withAnimation: NSTableViewAnimationOptions.EffectGap)
        //Select the new bug and scroll to make sure it's visible.
        self.bugsTableView.selectRowIndexes(NSIndexSet(index: newRowIndex), byExtendingSelection: false)
        self.bugsTableView.scrollRowToVisible(newRowIndex)
    }
    
    @IBAction func bugTitleDidEndEdit(sender: AnyObject) {
        if let selectedDoc = selectedBugDoc() {
            selectedDoc.data.title = self.bugTitleView.stringValue
            reloadSelectedBugRow()
        }
    }
    
    @IBAction func changePicture(sender: AnyObject) {
        if let _ = selectedBugDoc() {
            IKPictureTaker().beginPictureTakerSheetForWindow(self.view.window, withDelegate: self, didEndSelector: "pictureTakerDidEnd:returnCode:contextInfo:", contextInfo: nil)
        }
    }
    
    func pictureTakerDidEnd(picker: IKPictureTaker, returnCode: NSInteger, contextInfo: UnsafePointer<Void>) {
        let image = picker.outputImage()
        if image != nil && returnCode == NSModalResponseOK {
            self.bugImageView.image = image
            if let selectedDoc = selectedBugDoc() {
                selectedDoc.fullImage = image
                selectedDoc.thumbImage = image.imageByScalingAndCroppingForSize(CGSize(width: 44, height: 44))
                reloadSelectedBugRow()
            }
        }
    }
    
    @IBAction func resetData(sender: AnyObject) {
        setupSampleBugs()
        updateDetailInfo(nil)
        bugsTableView.reloadData()
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
    func starsSelectionChanged(control: EDStarRating!, rating: Float) {
        if let selectedDoc = selectedBugDoc() {
            selectedDoc.data.rating = Double(self.bugRating.rating)
        }
    }
}
