

import UIKit

class RootViewController : UITableViewController, UISearchBarDelegate {
    var sectionNames = [String]()
    var sectionData = [[String]]()
    var searcher = UISearchController()
    
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
        self.tableView.backgroundColor = UIColor.yellowColor()
        
        // this is the only important part of this class! create popover searcher
        
        // instantiate a view controller that will present the search results
        let src = SearchResultsController(data: self.sectionData)
        // instantiate a search controller and keep it alive
        let searcher = UISearchController(searchResultsController: src)
        self.searcher = searcher
        // make it a popover!
        searcher.modalPresentationStyle = .Popover
        // specify who the search controller should notify when the search bar changes
        searcher.searchResultsUpdater = src
        // put the search controller's search bar into the interface
        let b = searcher.searchBar
        // b.sizeToFit()
        // b.frame.size.width = 250
        b.autocapitalizationType = .None
        self.navigationItem.titleView = b
        b.showsCancelButton = true // no effect

        
        // could proceed to configure the UISearchController further...
        // or could configure its presentationController (a UIPopoverPresentationController)
        // but there is no need; the defaults are fine
        
        // however, I'm having difficulty detecting dismissal of the popover
        searcher.delegate = self
        searcher.presentationController?.delegate = self
//        (searcher.presentationController as UIPopoverPresentationController).delegate = self
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
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
    return self.sectionNames[section]
    }
    
    */
    // this is more "interesting"
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let h = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as! UITableViewHeaderFooterView
        if h.tintColor != UIColor.redColor() {
            // println("configuring a new header view") // only called about 7 times
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
    
    /*
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    println(view) // prove we are reusing header views
    }
    */
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject] {
        return self.sectionNames
    }
    
}

extension RootViewController : UISearchControllerDelegate {
    func willPresentSearchController(searchController: UISearchController) { println(__FUNCTION__) }
    func didPresentSearchController(searchController: UISearchController) { println(__FUNCTION__) }
    // but these are never called; I regard this as a bug
    func willDismissSearchController(searchController: UISearchController) { println(__FUNCTION__) }
    func didDismissSearchController(searchController: UISearchController) { println(__FUNCTION__) }
}
extension RootViewController : UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        println("prepare")
    }
    func popoverPresentationControllerShouldDismissPopover(pop: UIPopoverPresentationController) -> Bool {
        println("pop should dismiss")
        self.searcher.searchBar.text = nil // woo-hoo! fix dismissal failure to empty
        return true
    }
    func popoverPresentationControllerDidDismissPopover(pop: UIPopoverPresentationController) {
        println("pop dismiss")
        self.searcher.presentationController?.delegate = self // this is the big bug fix
    }
}


