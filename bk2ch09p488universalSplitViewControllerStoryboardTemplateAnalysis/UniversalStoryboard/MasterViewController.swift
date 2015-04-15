
import UIKit

class MasterViewController: UITableViewController {
    
    // pure template code, except I shortened some names, made it more swifty
    // I've added some comments and logging
    
    // var detail: DetailViewController? = nil
    var objects = [NSDate]()
    
    override func prefersStatusBarHidden() -> Bool {
        return true // no effect
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            // not sure what this next line does, if anything
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        // these next lines do not actually do anything, 
        // so I've taken them out as they are just confusing
        // obviously, though, if we were not using a storyboard and segue we would need them
        // in order to know how to transition to the next view controller
//        if let split = self.splitViewController {
//            let vcs = split.viewControllers
//            self.detail = vcs[vcs.count-1].topViewController as? DetailViewController
//            println("self.detail:")
//            println(self.detail)
//        }
    }
    
    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let ip = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([ip], withRowAnimation: .Automatic)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let ip = self.tableView.indexPathForSelectedRow()!
            let object = objects[ip.row] as NSDate
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            println("prepare for segue")
            println("object: \(object)")
            controller.detailItem = object
            // again, duplication from AppDelegate
            // the problem is that if we do this segue...
            // the detail view navigation controller is completely replaced,
            // so we must re-add the button
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true

        }
    }

    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let object = objects[indexPath.row] as NSDate
        cell.textLabel!.text = object.description
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}

extension MasterViewController {
    override func collapseSecondaryViewController(secondaryViewController: UIViewController, forSplitViewController splitViewController: UISplitViewController) {
        println("master view controller collapse")
        super.collapseSecondaryViewController(secondaryViewController, forSplitViewController: splitViewController)
    }
    
    override func targetViewControllerForAction(action: Selector, sender: AnyObject?) -> UIViewController? {
        println("master view controller target for \(action) \(sender)...")
        let result = super.targetViewControllerForAction(action, sender: sender)
        println("master view controller target for \(action), returning \(result)")
        return result
    }
    
    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        println("master view controller showViewController")
        super.showViewController(vc, sender: sender)
    }
    
    // NB it turns out it's important NOT to implement showDetailViewController here at all!
    // if we do, targetViewControllerForAction will return this vc, which is wrong
    // and we'll get an endless cycle.
    // The whole point of targetViewControllerForAction here is that we want it to find
    // the split view controller
    
    override func showDetailViewController(vc: UIViewController, sender: AnyObject?) {
        println("master view controller showDetailViewController")
        super.showDetailViewController(vc, sender: sender)
    }
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        let ok = super.respondsToSelector(aSelector)
        if aSelector == "showDetailViewController:sender:" {
            println("master responds? \(ok)")
        }
        return ok
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        var ok = super.canPerformAction(action, withSender:sender)
        if action == "showDetailViewController:sender:" {
            ok = false
            println("master can perform? \(ok)")
        }
        return ok
    }
    
    
        
}

