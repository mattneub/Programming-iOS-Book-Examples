

import UIKit
import CoreMotion

class MyTableViewController: UITableViewController {
    
    let actman = CMMotionActivityManager()
    var authorized = false
    var data : [CMMotionActivity]!
    var queue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b = UIBarButtonItem(title: "Start", style: .Plain, target: self, action: "doStart:")
        self.navigationItem.rightBarButtonItem = b
        
        let ok = CMStepCounter.isStepCountingAvailable()
        println("step counting: \(ok)")
        let ok2 = CMPedometer.isStepCountingAvailable()
        println("pedometer: \(ok2)")
        let ok3 = CMPedometer.isDistanceAvailable()
        println("distance: \(ok3)")
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
        self.actman.queryActivityStartingFromDate(now, toDate:now, toQueue:self.queue) {
            (arr:[AnyObject]!, err:NSError!) in
            let notauth = Int(CMErrorMotionActivityNotAuthorized.value)
            if err != nil && err.code == notauth {
                println("no authorization")
                self.authorized = false
            } else {
                println("authorized")
                self.authorized = true
            }
        }
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
        self.actman.queryActivityStartingFromDate(yester, toDate: now, toQueue: NSOperationQueue.mainQueue()) {
            (arr:[AnyObject]!, err:NSError!) -> Void in
            var acts = arr as! [CMMotionActivity]
            // crude filter: eliminate empties, low-confidence, and successive duplicates
            for i in stride(from: acts.count-1, through: 0, by: -1) {
                if acts[i].overallAct() == "f f f f f" {
                    acts.removeAtIndex(i)
                }
            }
            for i in stride(from: acts.count-1, through: 0, by: -1) {
                if acts[i].confidence.rawValue < 2 {
                    acts.removeAtIndex(i)
                }
            }
            for i in stride(from: acts.count-1, through: 1, by: -1) {
                if acts[i].overallAct() == acts[i-1].overallAct() {
                    acts.removeAtIndex(i)
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.data = acts
                self.tableView.reloadData()
            }
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.data != nil {
            return 1
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.data != nil {
            return self.data.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let act = self.data[indexPath.row]
        let format = NSDateFormatter()
        format.dateFormat = "MMM d, HH:mm:ss"
        cell.textLabel!.text = format.stringFromDate(act.startDate)
        cell.detailTextLabel!.text = act.overallAct()
        
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
