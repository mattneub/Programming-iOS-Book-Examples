
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
        print("\(self) " + __FUNCTION__)
        if let tc = self.transitionCoordinator() {
            print(tc)
        }
        guard let tc = self.transitionCoordinator() else {return}
        guard tc.initiallyInteractive() else {return}
        tc.notifyWhenInteractionEndsUsingBlock {
            context in
            if context.isCancelled() {
                print("we got cancelled")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + __FUNCTION__)
        if let tc = self.transitionCoordinator() {
            print(tc)
        }
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + __FUNCTION__)
        
        if let tc = self.transitionCoordinator() {
            print(tc)
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + __FUNCTION__)
        if let tc = self.transitionCoordinator() {
            print(tc)
        }
        
    }

    
}