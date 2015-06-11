

import UIKit

class RootViewController : UITableViewController {
    var sectionNames = [String]()
    var sectionData = [[String]]()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        let s = String(contentsOfFile: NSBundle.mainBundle().pathForResource("states", ofType: "txt")!, encoding: NSUTF8StringEncoding, error: nil)!
        let states = s.componentsSeparatedByString("\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = (aState as NSString).substringWithRange(NSMakeRange(0,1))
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
        // anyone know what this does????
        // self.tableView.separatorEffect = UIBlurEffect(style: .Dark)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionData[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
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
    
    /*
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    }
    */

    // this is more "interesting"
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as! UITableViewHeaderFooterView
        if h.tintColor != UIColor.redColor() {
            println("configuring a new header view") // only called about 7 times
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
            lab.setTranslatesAutoresizingMaskIntoConstraints(false)
            v.setTranslatesAutoresizingMaskIntoConstraints(false)
            h.contentView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[lab(25)]-10-[v(40)]",
                    options:nil, metrics:nil, views:["v":v, "lab":lab]))
            h.contentView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|",
                    options:nil, metrics:nil, views:["v":v]))
            h.contentView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[lab]|",
                    options:nil, metrics:nil, views:["lab":lab]))
//            let b = UIButton.buttonWithType(.System) as UIButton
//            b.setTitle("Howdy", forState:.Normal)
//            b.sizeToFit()
//            println(b.tintColor)
//            h.addSubview(b)
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sectionNames[section]
        return h
        
    }
    
    /*
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    println(view) // prove we are reusing header views
    }
    */
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return self.sectionNames
    }
}
