
import UIKit

class MasterViewController: UITableViewController {
    
    // pure template code, except I shortened some names, made it more swifty
    // I've added some comments and logging
    
    // var detail: DetailViewController? = nil
    var objects = [NSDate]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            // not sure what this next line does, if anything
            // self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
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
//            print("self.detail:")
//            print(self.detail)
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
            let ip = self.tableView.indexPathForSelectedRow!
            let object = objects[ip.row] as NSDate
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            print("prepare for segue")
            print(object)
            controller.detailItem = object
            // just proving that when collapsed, svc has just the one child
            // basically that child is now in total charge of the interface
            print("children of svc: \(self.splitViewController!.viewControllers)")
            // again, duplication from AppDelegate
            // the problem is that if we do this segue...
            // the detail view navigation controller is completely replaced,
            // so we must re-add the button
//            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
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

