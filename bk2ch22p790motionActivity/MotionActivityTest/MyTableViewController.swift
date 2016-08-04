

import UIKit
import CoreMotion

class MyTableViewController: UITableViewController {
    
    let actman = CMMotionActivityManager()
    var authorized = false
    var data : [CMMotionActivity]!
    var queue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(doStart))
        self.navigationItem.rightBarButtonItem = b
        
//        let ok = CMStepCounter.isStepCountingAvailable()
//        print("step counting: \(ok)")
        let ok2 = CMPedometer.isStepCountingAvailable()
        print("pedometer: \(ok2)")
        let ok3 = CMPedometer.isDistanceAvailable()
        print("distance: \(ok3)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkAuthorization()
    }
    
    func checkAuthorization() {
        if !CMMotionActivityManager.isActivityAvailable() {
            print("darn")
            return
        }
        // there is also CMPedometer and various is...Available in iOS 8 on a subset of devices
        // there is no direct authorization check
        // instead, we attempt to "tickle" the activity manager and see if we get an error
        // this will cause the system authorization dialog to be presented if necessary
        let now = Date()
        self.actman.queryActivityStarting(from: now, to:now, to:.main) {
            (arr:[CMMotionActivity]?, err:NSError?) in
            let notauth = Int(CMErrorMotionActivityNotAuthorized.rawValue)
            if err != nil && err!.code == notauth {
                print("no authorization")
                self.authorized = false
            } else {
                print("authorized")
                self.authorized = true
            }
        }
    }
    
    func doStart(_ sender:AnyObject!) {
        if !self.authorized {
            self.checkAuthorization()
            return
        }
        // there are two approaches: live and historical
        // collect historical data
        let now = Date()
        let yester = now + (-60*60*24) // !
        self.actman.queryActivityStarting(from: yester, to: now, to: self.queue) {
            (arr:[CMMotionActivity]?, err:NSError?) -> Void in
            guard var acts = arr else {return}
            // crude filter: eliminate empties, low-confidence, and successive duplicates
            let blank = "f f f f f f"
            acts = acts.filter {act in act.overallAct() != blank}
            acts = acts.filter {act in act.confidence == .high}
            acts = acts.filter {act in !(act.automotive && act.stationary)}
            for i in (1..<acts.count).reversed() {
                if acts[i].overallAct() == acts[i-1].overallAct() {
                    print("removing act identical to previous")
                    acts.remove(at:i)
                }
            }
            DispatchQueue.main.async {
                self.data = acts
                self.tableView.reloadData()
            }
            /*
            let format = NSDateFormatter()
            format.dateFormat = "MMM d, HH:mm:ss"
            
            for act in acts {
                print("=======")
                print(format.stringFromDate(act.startDate))
                print("S W R A U")
                print(self.overallAct(act))
            }
            */
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.data != nil {
            return 1
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.data != nil {
            return self.data.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) 

        let act = self.data[indexPath.row]
        let format = DateFormatter()
        format.dateFormat = "MMM d, HH:mm:ss"
        cell.textLabel!.text = format.string(from: act.startDate)
        cell.detailTextLabel!.text = act.overallAct()
        
        cell.backgroundColor = .white
        if act.automotive {
            cell.backgroundColor = UIColor.red()
        }
        if act.walking || act.running {
            cell.backgroundColor = UIColor.green()
        }

        return cell
    }


}
