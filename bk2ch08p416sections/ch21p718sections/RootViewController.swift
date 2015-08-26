

import UIKit

class RootViewController : UITableViewController {
    var sectionNames = [String]()
    var sectionData = [[String]]()
    
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
                self.sectionNames.append(c.uppercaseString)
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append([String]())
            }
            sectionData[sectionData.count-1].append(aState)
        }
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        
        self.tableView.sectionIndexColor = UIColor.whiteColor()
        self.tableView.sectionIndexBackgroundColor = UIColor.redColor()
        self.tableView.sectionIndexTrackingBackgroundColor = UIColor.blueColor()
        // not useful in this situation
        // self.tableView.separatorEffect = UIBlurEffect(style: .Dark)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
        // return self.sectionNames[section]
    }

    // this is more "interesting"
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header")!
        if h.tintColor != UIColor.redColor() {
            print("configuring a new header view") // only called about 7 times
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
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[lab(25)]-10-[v(40)]",
                    options:[], metrics:nil, views:["v":v, "lab":lab]),
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|",
                    options:[], metrics:nil, views:["v":v]),
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[lab]|",
                    options:[], metrics:nil, views:["lab":lab])
                ].flatten().map{$0})
            
            // uncomment to see bug where button does not inherit superview's tint color
//            let b = UIButton(type:.System)
//            b.setTitle("Howdy", forState:.Normal)
//            b.sizeToFit()
//            print(b.tintColor)
//            h.addSubview(b)
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sectionNames[section]
        return h
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
        return UITableViewAutomaticDimension
    }
    
    /*
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    println(view) // prove we are reusing header views
    }
    */
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.sectionNames
    }
}
