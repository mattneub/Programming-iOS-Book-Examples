

import UIKit
import CoreMotion

class MyTableViewController: UITableViewController {
    
    let motman = CMMotionActivityManager()
    var authorized = false
    var data : [CMMotionActivity]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b = UIBarButtonItem(title: "Start", style: .Plain, target: self, action: "doStart:")
        self.navigationItem.rightBarButtonItem = b
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.checkAuthorization()
    }
    
    func checkAuthorization() {
        if !CMMotionActivityManager.isActivityAvailable() {
            println("darn")
            return
        }
        // there is also CMPedometer and various is...Available in iOS 8 on a subset of devices
        // there is no direct authorization check
        // instead, we attempt to "tickle" the activity manager and see if we get an error
        // this will cause the system authorization dialog to be presented if necessary
        let now = NSDate()
        motman.queryActivityStartingFromDate(now, toDate:now, toQueue:NSOperationQueue.mainQueue()) {
            (arr:[AnyObject]!, err:NSError!) in
            if err != nil && err.code == Int(CMErrorMotionActivityNotAuthorized.value) {
                // hmm, but I'm getting a nil error here even though we are not authorized
                // but I do get an empty array, we could check for that I suppose
                // perhaps an iOS 7 bug, and I can't test on iOS 8 yet
                println("no authorization")
            } else {
                self.authorized = true
            }
        }
    }
    
    func tf(b:Bool) -> String {
        return b ? "t" : "f"
    }
    
    func overallAct(act:CMMotionActivity) -> String {
        let s = self.tf(act.stationary)
        let w = self.tf(act.walking)
        let r = self.tf(act.running)
        let a = self.tf(act.automotive)
        let u = self.tf(act.unknown)
        return "\(s) \(w) \(r) \(a) \(u)"
    }

    func doStart(sender:AnyObject!) {
        if !self.authorized {
            self.checkAuthorization()
            return
        }
        // there are two approaches: live and historical
        // collect historical data
        let now = NSDate()
        let yester = now.dateByAddingTimeInterval(-60*60*24)
        self.motman.queryActivityStartingFromDate(yester, toDate: now, toQueue: NSOperationQueue.mainQueue()) {
            (arr:[AnyObject]!, err:NSError!) -> Void in
            var acts = arr as [CMMotionActivity]
            // crude filter: eliminate empties, low-confidence, and successive duplicates
            for i in stride(from: acts.count-1, through: 0, by: -1) {
                if self.overallAct(acts[i]) == "f f f f f" {
                    acts.removeAtIndex(i)
                }
            }
            for i in stride(from: acts.count-1, through: 0, by: -1) {
                if acts[i].confidence.toRaw() < 2 {
                    acts.removeAtIndex(i)
                }
            }
            for i in stride(from: acts.count-1, through: 1, by: -1) {
                if self.overallAct(acts[i]) == self.overallAct(acts[i-1]) {
                    acts.removeAtIndex(i)
                }
            }
            self.data = acts
            self.tableView.reloadData()
            
            /*
            let format = NSDateFormatter()
            format.dateFormat = "MMM d, HH:mm:ss"
            
            for act in acts {
                println("=======")
                println(format.stringFromDate(act.startDate))
                println("S W R A U")
                println(self.overallAct(act))
            }
            */
            
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        if self.data != nil {
            return 1
        }
        return 0
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if self.data != nil {
            return self.data.count
        }
        return 0
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let act = self.data[indexPath.row]
        let format = NSDateFormatter()
        format.dateFormat = "MMM d, HH:mm:ss"
        cell.textLabel.text = format.stringFromDate(act.startDate)
        cell.detailTextLabel.text = self.overallAct(act)
        
        cell.backgroundColor = UIColor.whiteColor()
        if act.automotive {
            cell.backgroundColor = UIColor.redColor()
        }
        if act.walking || act.running {
            cell.backgroundColor = UIColor.greenColor()
        }

        return cell
    }


}
