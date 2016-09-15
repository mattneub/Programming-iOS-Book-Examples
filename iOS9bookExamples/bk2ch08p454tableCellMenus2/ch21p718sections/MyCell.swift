

import UIKit

class MyCell : UITableViewCell {
    
    func abbrev(sender:AnyObject!) {
        // find my table view
        var v : UIView = self
        repeat {v = v.superview!} while !(v is UITableView)
        let tv = v as! UITableView
        // ask it what index path we are
        let ip = tv.indexPathForCell(self)!
        // talk to its delegate
        tv.delegate?.tableView?(tv, performAction:#selector(abbrev), forRowAtIndexPath:ip, withSender:sender)
    }

}
