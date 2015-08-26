

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class MyHeaderView : UITableViewHeaderFooterView {
    var section = 0
    // just testing reuse
    deinit {
        print ("farewell from a header, section \(section)")
    }
}

class RootViewController : UITableViewController {
    var sectionNames = [String]()
    var sectionData = [[String]]()
    var hiddenSections = Set<Int>()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        let s = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("states", ofType: "txt")!, encoding: NSUTF8StringEncoding)
        let states = s.componentsSeparatedByString("\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = String(aState.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append( c.uppercaseString )
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append( [String]() )
            }
            sectionData[sectionData.count-1].append( aState )
        }
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(
            MyHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header") //*
        
        self.tableView.sectionIndexColor = UIColor.whiteColor()
        self.tableView.sectionIndexBackgroundColor = UIColor.redColor()
        self.tableView.sectionIndexTrackingBackgroundColor = UIColor.blueColor()
        return; // just testing reuse
        delay(5) {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections.contains(section) { // *
            return 0
        }
        return self.sectionData[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let s = self.sectionData[indexPath.section][indexPath.row]
        cell.textLabel!.text = s
        
        // this part is not in the book, it's just for fun
        var stateName = s
        stateName = stateName.lowercaseString
        stateName = stateName.stringByReplacingOccurrencesOfString(" ", withString:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        cell.imageView!.image = im
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView
            .dequeueReusableHeaderFooterViewWithIdentifier("Header") as! MyHeaderView
        if h.tintColor != UIColor.redColor() {
            h.tintColor = UIColor.redColor() // invisible marker, tee-hee
            h.backgroundView = UIView()
            h.backgroundView?.backgroundColor = UIColor.blackColor()
            let lab = UILabel()
            lab.tag = 1
            lab.font = UIFont(name:"Georgia-Bold", size:22)
            lab.textColor = UIColor.greenColor()
            lab.backgroundColor = UIColor.clearColor()
            h.contentView.addSubview(lab)
            let v = UIImageView()
            v.tag = 2
            v.backgroundColor = UIColor.blackColor()
            v.image = UIImage(named:"us_flag_small.gif")
            h.contentView.addSubview(v)
            lab.translatesAutoresizingMaskIntoConstraints = false
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activateConstraints([
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|-5-[lab(25)]-10-[v(40)]",
                    options:[], metrics:nil, views:["v":v, "lab":lab]),
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|[v]|",
                    options:[], metrics:nil, views:["v":v]),
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|[lab]|",
                    options:[], metrics:nil, views:["lab":lab])
                ].flatten().map{$0})
            // add tap g.r.
            let tap = UITapGestureRecognizer(target: self, action: "tap:") // *
            tap.numberOfTapsRequired = 2 // *
            h.addGestureRecognizer(tap) // *
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sectionNames[section]
        h.section = section // *
        return h
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.sectionNames
    }
    
    func tap (g : UIGestureRecognizer) {
        let v = g.view as! MyHeaderView
        let sec = v.section
        let ct = self.sectionData[sec].count
        let arr = (0..<ct).map {NSIndexPath(forRow:$0, inSection:sec)} // whoa! ***
        if self.hiddenSections.contains(sec) {
            self.hiddenSections.remove(sec)
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(arr,
                withRowAnimation:.Automatic)
            self.tableView.endUpdates()
            self.tableView.scrollToRowAtIndexPath(arr[ct-1],
                atScrollPosition:.None,
                animated:true)
        } else {
            self.hiddenSections.insert(sec)
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths(arr,
                withRowAnimation:.Automatic)
            self.tableView.endUpdates()
        }

    }
}
