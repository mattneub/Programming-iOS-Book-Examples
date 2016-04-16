

import UIKit

class RootViewController : UITableViewController {
    
    override func tableView(_ tv: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        // we can still modify the cell as long as we fetch it from super
        let cell = super.tableView(tv, cellForRowAt:indexPath)
        
        // supply checkmarks as necessary
        let ud = NSUserDefaults.standard()
        
        NSLog("about to update %@", cell.textLabel!.text! as NSObject)
        cell.accessoryType = .none
        if ud.value(forKey:"Style") as? String == cell.textLabel!.text! ||
            ud.value(forKey:"Size") as? String == cell.textLabel!.text! {
                cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func log(tv:UITableView, ip:NSIndexPath, phrase:String) {
        NSLog("%@", "========")
        NSLog("%@ %@", phrase as NSObject, tv.cellForRow(at:ip)!.textLabel!.text! as NSObject)
        NSLog("cell highlighted? %@", "\(tv.cellForRow(at:ip)!.isHighlighted)" as NSObject)
        NSLog("label highlighted? %@", "\(tv.cellForRow(at:ip)!.textLabel!.isHighlighted)" as NSObject)
    }
    
    override func tableView(_ tv: UITableView, shouldHighlightRowAt indexPath: NSIndexPath) -> Bool {
        log(tv: tv, ip: indexPath, phrase: "should highlight")
        
        dispatch_async(dispatch_get_main_queue(), {
            NSLog("%@", "callback from should highlight")
            })
        
        return true // try false to test this feature
    }
    
    override func tableView(_ tv: UITableView, didHighlightRowAt indexPath: NSIndexPath) {
        log(tv: tv, ip: indexPath, phrase: "did highlight")
    }
    
    override func tableView(_ tv: UITableView, didUnhighlightRowAt indexPath: NSIndexPath) {
        log(tv: tv, ip: indexPath, phrase: "did unhighlight")
        
        dispatch_async(dispatch_get_main_queue(), {
            NSLog("%@", "callback from did unhighlight")
            })
    }
    
    override func tableView(_ tv: UITableView, willSelectRowAt indexPath: NSIndexPath) -> NSIndexPath? {
        log(tv: tv, ip: indexPath, phrase: "will select")
        
        return indexPath
    }
    
    override func tableView(_ tv: UITableView, willDeselectRowAt indexPath: NSIndexPath) -> NSIndexPath? {
        log(tv: tv, ip: indexPath, phrase: "will deselect")
        
        return indexPath
    }
    
    override func tableView(_ tv: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        log(tv: tv, ip: indexPath, phrase: "did select")
        
        let ud = NSUserDefaults.standard()
        let setting = tv.cellForRow(at:indexPath)!.textLabel!.text
        let header = self.tableView(tv, titleForHeaderInSection:indexPath.section)!
        ud.setValue(setting! as AnyObject, forKey:header)
        
        NSLog("%@", "about to reload!")
        tv.reloadData() // deselect all cells, reassign checkmark as needed

    }
    
    override func tableView(_ tv: UITableView, didDeselectRowAt indexPath: NSIndexPath) {
        NSLog("did deselect %@", tv.cellForRow(at:indexPath)!.textLabel!.text! as NSObject)
    }
    
    // just proving this stuff works even in a grouped style table
    
    /*


    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear()
        // v.backgroundColor = UIColor.yellow()
        // tableView.backgroundColor = UIColor.green()
        return v
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.blue()
        return v
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

*/
    
}
