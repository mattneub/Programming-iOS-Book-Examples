

import UIKit

class RootViewController : UITableViewController, UISearchBarDelegate {
    var sectionNames = [String]()
    var sectionData = [[String]]()
    var searcher = UISearchController()
    
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
        self.tableView.backgroundView = {
            let v = UIView()
            v.backgroundColor = UIColor.yellowColor()
            return v
            }()
        
        let src = SearchResultsController() // we will configure later
        let searcher = UISearchController(searchResultsController: src)
        self.searcher = searcher
        searcher.delegate = self // so we can configure results controller and presentation
        // put the search controller's search bar into the interface
        let b = searcher.searchBar
        b.autocapitalizationType = .None
        b.sizeToFit()
        b.scopeButtonTitles = ["Starts", "Contains"] // won't show in the table
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
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return self.sectionNames
    }
}

extension RootViewController : UISearchControllerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    func presentSearchController(sc: UISearchController) {
        println("search!")
        // good opportunity to control timing of search results controller configuration
        let src = sc.searchResultsController as! SearchResultsController
        src.takeData(self.sectionData) // that way if it changes we are up to date
        sc.searchResultsUpdater = src
        sc.searchBar.delegate = src

        sc.transitioningDelegate = self
        sc.modalPresentationStyle = .Custom // ?
        self.presentViewController(sc, animated: true, completion: nil)
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        let p = UIPresentationController(presentedViewController: presented, presentingViewController: presenting)
        println("wow") // never called, sorry
        return p
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let vc1 = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let vc2 = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let con = transitionContext.containerView()
        
        let r1start = transitionContext.initialFrameForViewController(vc1)
        let r2end = transitionContext.finalFrameForViewController(vc2)
        
        let v1 = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let v2 = transitionContext.viewForKey(UITransitionContextToViewKey)

        if let v2 = v2 { // presenting, vc2 is the search controller
            
            // our responsibilities are:
            // get vc2 into the interface, obviously
            // get **the search bar** into the presented interface!
            // and we can animate that
            // (plus we are responsible for the Cancel button)
            
            con.addSubview(v2)
            v2.frame = r2end
            let sc = vc2 as! UISearchController
            let sb = sc.searchBar
            sb.removeFromSuperview()
            // hold my beer and watch _this_!
            sb.showsScopeBar = true
            sb.sizeToFit()
            v2.addSubview(sb)
            sb.frame.origin.y = -sb.frame.height
            UIView.animateWithDuration(0.3, animations: {
                sb.frame.origin.y = 0
                }, completion: {
                    _ in
                    sb.setShowsCancelButton(true, animated: true)
                    transitionContext.completeTransition(true)
                })
        } else { // dismissing, vc1 is the search controller
            
            // we have no major responsibilities...
            // but if we showed the cancel button and we don't want it in the normal interface,
            // we need to get rid of it now; similarly with the scope bar
            
            let sc = vc1 as! UISearchController
            let sb = sc.searchBar
            sb.showsCancelButton = false
            sb.showsScopeBar = false
            sb.sizeToFit()

            UIView.animateWithDuration(0.3, animations: {
                }, completion: {
                    _ in
                    transitionContext.completeTransition(true)
                })
        }
        
    }

}
