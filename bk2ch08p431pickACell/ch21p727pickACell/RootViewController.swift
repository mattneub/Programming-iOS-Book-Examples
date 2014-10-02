

import UIKit

class RootViewController : UITableViewController {
    
    override func tableView(tv: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // we can still modify the cell as long as we fetch it from super
        let cell = super.tableView(tv, cellForRowAtIndexPath:indexPath) as UITableViewCell
        
        // supply checkmarks as necessary
        let ud = NSUserDefaults.standardUserDefaults()
        
        NSLog("about to update %@", cell.textLabel!.text!)
        cell.accessoryType = .None
        if ud.valueForKey("Style") as? String == cell.textLabel!.text! ||
            ud.valueForKey("Size") as? String == cell.textLabel!.text! {
        cell.accessoryType = .Checkmark
        }
        return cell
    }
    
    func log(#tv:UITableView, ip:NSIndexPath, phrase:String) {
        NSLog("%@", "========")
        NSLog("%@ %@", phrase, tv.cellForRowAtIndexPath(ip)!.textLabel!.text!)
        NSLog("cell highlighted? %@", "\(tv.cellForRowAtIndexPath(ip)!.highlighted)")
        NSLog("label highlighted? %@", "\(tv.cellForRowAtIndexPath(ip)!.textLabel!.highlighted)")
    }
    
    override func tableView(tv: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        log(tv: tv, ip: indexPath, phrase: "should highlight")
        
        dispatch_async(dispatch_get_main_queue(), {
            NSLog("%@", "callback from should highlight")
            })
        
        return true // try false to test this feature
    }
    
    override func tableView(tv: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        log(tv: tv, ip: indexPath, phrase: "did highlight")
    }
    
    override func tableView(tv: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        log(tv: tv, ip: indexPath, phrase: "did unhighlight")
        
        dispatch_async(dispatch_get_main_queue(), {
            NSLog("%@", "callback from did unhighlight")
            })
    }
    
    override func tableView(tv: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        log(tv: tv, ip: indexPath, phrase: "will select")
        
        return indexPath
    }
    
    override func tableView(tv: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        log(tv: tv, ip: indexPath, phrase: "will deselect")
        
        return indexPath
    }
    
    override func tableView(tv: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        log(tv: tv, ip: indexPath, phrase: "did select")
        
        let ud = NSUserDefaults.standardUserDefaults()
        let setting = tv.cellForRowAtIndexPath(indexPath)!.textLabel!.text
        let header = self.tableView(tv, titleForHeaderInSection:indexPath.section)!
        ud.setValue(setting, forKey:header)
        
        NSLog("%@", "about to reload!")
        tv.reloadData() // deselect all cells, reassign checkmark as needed

    }
    
    override func tableView(tv: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("did deselect %@", tv.cellForRowAtIndexPath(indexPath)!.textLabel!.text!)
    }

    
}
