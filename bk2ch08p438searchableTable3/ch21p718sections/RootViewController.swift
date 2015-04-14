

import UIKit

class RootViewController : UITableViewController, UISearchBarDelegate {
    var sectionNames = [String]()
    var sectionData = [[String]]()
    var originalSectionNames = [String]()
    var originalSectionData = [[String]]()
    var searcher = UISearchController()
    var searching = false
    
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
                self.sectionNames.append( c.uppercaseString )
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append( [String]() )
            }
            sectionData[sectionData.count-1].append( aState )
        }
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        
        self.tableView.sectionIndexColor = UIColor.whiteColor()
        self.tableView.sectionIndexBackgroundColor = UIColor.redColor()
        // self.tableView.sectionIndexTrackingBackgroundColor = UIColor.blueColor()
        // self.tableView.backgroundColor = UIColor.yellowColor()
        self.tableView.backgroundView = { // this will fix it
            let v = UIView()
            v.backgroundColor = UIColor.yellowColor()
            return v
            }()
        
        // in this version, we take the total opposite approach:
        // we don't present any extra view at all!
        // we already have a table, so why not just filter the very same table?
        // to do so, pass nil as the search results controller,
        // and tell the search controller not to insert a dimming view
        
        // keep copies of the original data
        self.originalSectionData = self.sectionData
        self.originalSectionNames = self.sectionNames
        let searcher = UISearchController(searchResultsController:nil)
        self.searcher = searcher
        searcher.dimsBackgroundDuringPresentation = false
        searcher.searchResultsUpdater = self
        searcher.delegate = self
        // put the search controller's search bar into the interface
        let b = searcher.searchBar
        b.sizeToFit() // crucial, trust me on this one
        b.autocapitalizationType = .None
        self.tableView.tableHeaderView = b
        self.tableView.reloadData()
        self.tableView.scrollToRowAtIndexPath(
            NSIndexPath(forRow: 0, inSection: 0),
            atScrollPosition:.Top, animated:false)
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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as! UITableViewHeaderFooterView
        if h.tintColor != UIColor.redColor() {
            h.tintColor = UIColor.redColor() // invisible marker, tee-hee
            h.backgroundView = UIView()
            h.backgroundView!.backgroundColor = UIColor.blackColor()
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
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sectionNames[section]
        return h
    }
    
    // much nicer without section index during search
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return self.searching ? nil : self.sectionNames
    }
}

extension RootViewController : UISearchControllerDelegate {
    // flag for whoever needs it (in this case, sectionIndexTitles...)
    func willPresentSearchController(searchController: UISearchController) {
        self.searching = true
    }
    func willDismissSearchController(searchController: UISearchController) {
        self.searching = false
    }
}

extension RootViewController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let sb = searchController.searchBar
        let target = sb.text
        if target == "" {
            self.sectionNames = self.originalSectionNames
            self.sectionData = self.originalSectionData
            self.tableView.reloadData()
            return
        }
        // we have a target string
        self.sectionData = self.originalSectionData.map {
            $0.filter {
                let options = NSStringCompareOptions.CaseInsensitiveSearch
                let found = $0.rangeOfString(target, options: options)
                return (found != nil)
            }
        }.filter {$0.count > 0} // is Swift cool or what?
        self.sectionNames = self.sectionData.map {prefix($0[0],1)}
        self.tableView.reloadData()
    }
}

