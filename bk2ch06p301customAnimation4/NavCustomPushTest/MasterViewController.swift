
import UIKit

class MasterViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let b = UIBarButtonItem(title: "Push", style: .Plain, target: self, action: "doPush:")
        self.navigationItem.rightBarButtonItem = b
    }
    
    func doPush(sender:AnyObject?) {
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            (segue.destinationViewController as DetailViewController).detailItem = NSDate()
        }
    }
    
}