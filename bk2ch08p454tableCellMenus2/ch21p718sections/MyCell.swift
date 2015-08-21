

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
        let action = Selector(__FUNCTION__ + ":") // work around weird way Swift expresses this
        tv.delegate?.tableView?(tv, performAction:action, forRowAtIndexPath:ip, withSender:sender)
    }

}
