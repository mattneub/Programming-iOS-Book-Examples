

import UIKit

class MyCell : UITableViewCell {
    
    func abbrev(_ sender:AnyObject!) {
        // find my table view
        var v : UIView = self
        repeat {v = v.superview!} while !(v is UITableView)
        let tv = v as! UITableView
        // ask it what index path we are
        let ip = tv.indexPath(for: self)!
        // talk to its delegate
        tv.delegate?.tableView?(tv, performAction:#selector(abbrev), forRowAt:ip, withSender:sender)
    }

}
