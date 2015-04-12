
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            (segue.destinationViewController as! DetailViewController).detailItem = NSDate()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("\(self) " + __FUNCTION__)
        if let tc = self.transitionCoordinator() {
            println(tc)
        }
        if let tc = self.transitionCoordinator() {
            if tc.initiallyInteractive() {
                tc.notifyWhenInteractionEndsUsingBlock {
                    context in
                    if context.isCancelled() {
                        println("we got cancelled")
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("\(self) " + __FUNCTION__)
        if let tc = self.transitionCoordinator() {
            println(tc)
        }
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("\(self) " + __FUNCTION__)
        
        if let tc = self.transitionCoordinator() {
            println(tc)
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("\(self) " + __FUNCTION__)
        if let tc = self.transitionCoordinator() {
            println(tc)
        }
        
    }

    
}