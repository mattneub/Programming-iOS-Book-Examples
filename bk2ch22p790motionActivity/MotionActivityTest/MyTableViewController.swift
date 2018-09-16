

import UIKit
import CoreMotion

class MyTableViewController: UITableViewController {
    
    let actman = CMMotionActivityManager()
    var isAuthorized = false
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
    
    func checkAuthorization(andThen f:(()->())? = nil) {
        guard CMMotionActivityManager.isActivityAvailable() else {
            print("darn")
            return
        }
        // new in iOS 11, we can just ask for the authorization status
        let status = CMMotionActivityManager.authorizationStatus()
        switch status {
        case .notDetermined: // bring up dialog
            let now = Date()
            self.actman.queryActivityStarting(from: now, to:now, to:.main) {
                _,err in
                print("asked for authorization")
                if err == nil {
                    f?()
                }
            }
        case .authorized: f?()
        case .restricted: break // do nothing
        case .denied: break // could beg for authorization here
        }
    }
    
    @objc func doStart(_ sender: Any!) {
        self.checkAuthorization(andThen: self.reallyStart)
    }
    
    private func reallyStart() {
        // there are two approaches: live and historical
        // collect historical data
        let now = Date()
        let yester = now - (60*60*24) // !
        self.actman.queryActivityStarting(from: yester, to: now, to: self.queue) { arr, err in
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
             let format = DateFormatter()
             format.dateFormat = "MMM d, HH:mm:ss"
             
             for act in acts {
             print("=======")
             print(format.string(from:act.startDate))
             print("S W R A U")
             // print(self.overallAct(act))
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

    let cellID = "Cell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) 

        let act = self.data[indexPath.row]
        let format = DateFormatter()
        format.dateFormat = "MMM d, HH:mm:ss"
        cell.textLabel!.text = format.string(from: act.startDate)
        cell.detailTextLabel!.text = act.overallAct()
        
        cell.backgroundColor = .white
        if act.automotive {
            cell.backgroundColor = .red
        }
        if act.walking || act.running {
            cell.backgroundColor = .green
        }

        return cell
    }

    func ignore() {
        let rec = CMSensorRecorder()
        if let list = rec.accelerometerData(from: Date(), to: Date()) {
            for datum in list {
                if let accdatum = datum as? CMRecordedAccelerometerData {
                    let accel = accdatum.acceleration
                    let t = accdatum.timestamp
                    // do something with data here
                    _ = (accel,t)
                }
            }
        }
    }
    
    func oldCode() {
        // before iOS 11, there is no direct authorization check
        // instead, we attempt to "tickle" the activity manager and see if we get an error
        // this will cause the system authorization dialog to be presented if necessary
        let now = Date()
        self.actman.queryActivityStarting(from: now, to:now, to:.main) { arr, err in
            // such Swift numeric barf you could plotz
            let notauth = Int(CMErrorMotionActivityNotAuthorized.rawValue)
            if err != nil && (err! as NSError).code == notauth {
                print("no authorization")
                self.isAuthorized = false
            } else {
                print("authorized")
                self.isAuthorized = true
            }
        }
    }

}

extension CMSensorDataList: Sequence {
    public typealias Iterator = NSFastEnumerationIterator
    public func makeIterator() -> NSFastEnumerationIterator {
        return NSFastEnumerationIterator(self)
    }
}

