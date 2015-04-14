

import UIKit
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class RootViewController: UITableViewController {
    
    var pep : [String]! = ["Manny", "Moe", "Jack"] // pretend model might not be ready
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl!.addTarget(self, action: "doRefresh", forControlEvents: .ValueChanged)
        
//        let v = UIView()
//        v.backgroundColor = UIColor.blackColor()
//        self.tableView.backgroundView = v
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.pep == nil {
            return 0
        }
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pep.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel!.text = pep[indexPath.row]
        return cell
    }

    @IBAction func doRefresh(sender: AnyObject) {
        println("refreshing...")
        delay(3) {
            (sender as! UIRefreshControl).endRefreshing()
            println("done")
        }
    }

    @IBAction func doRefreshManually(sender: AnyObject) {
        self.tableView.setContentOffset(
            CGPointMake(0, -self.refreshControl!.bounds.height),
            animated:true)
        self.refreshControl!.beginRefreshing()
        self.doRefresh(self.refreshControl!)
    }
}
