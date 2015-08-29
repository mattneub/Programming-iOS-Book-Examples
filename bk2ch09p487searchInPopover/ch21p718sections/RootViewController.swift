

import UIKit

class RootViewController : UITableViewController, UISearchBarDelegate {
    var sectionNames = [String]()
    var sectionData = [[String]]()
    var searcher : UISearchController!
    
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
        // no effect in this situation:
        searcher.hidesNavigationBarDuringPresentation = false
        // searcher.dimsBackgroundDuringPresentation = false
        // make it a popover!
        self.definesPresentationContext = true
        searcher.modalPresentationStyle = .Popover
        searcher.preferredContentSize = CGSizeMake(400,400)
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
        if let pres = searcher.presentationController {
            print("setting presentation controller delegate")
            pres.delegate = self
        }
//        (searcher.presentationController as UIPopoverPresentationController).delegate = self
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
    
    /*
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
    return self.sectionNames[section]
    }
    
    */
    // this is more "interesting"
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header")!
        if h.tintColor != UIColor.redColor() {
            // print("configuring a new header view") // only called about 7 times
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
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sectionNames[section]
        return h
        
    }
    
    /*
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    print(view) // prove we are reusing header views
    }
    */
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.sectionNames
    }
    
}

extension RootViewController : UISearchControllerDelegate {
    func presentSearchController(searchController: UISearchController) { print(__FUNCTION__) }
    func willPresentSearchController(searchController: UISearchController) { print(__FUNCTION__) }
    func didPresentSearchController(searchController: UISearchController) { print(__FUNCTION__) }
    // these next functions are not called, I regard this as a bug
    func willDismissSearchController(searchController: UISearchController) { print(__FUNCTION__) }
    func didDismissSearchController(searchController: UISearchController) { print(__FUNCTION__) }
}

extension RootViewController : UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(pop: UIPopoverPresentationController) {
        print("prepare")
//        print(pop.sourceView)
//        print(pop.passthroughViews)
//        print(pop.delegate)
    }
    func popoverPresentationControllerShouldDismissPopover(pop: UIPopoverPresentationController) -> Bool {
        print("pop should dismiss")
        self.searcher.searchBar.text = nil // woo-hoo! fix dismissal failure to empty
        return true
    }
    func popoverPresentationControllerDidDismissPopover(pop: UIPopoverPresentationController) {
        print("pop dismiss")
        self.searcher.presentationController?.delegate = self // this is the big bug fix
    }
}

// not called, seems like a bug to me

extension RootViewController : UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("waha")
        return .None
    }
}


