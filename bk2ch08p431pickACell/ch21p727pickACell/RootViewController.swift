

import UIKit

class RootViewController : UITableViewController {
    
    override func tableView(_ tv: UITableView, cellForRowAt ix: IndexPath) -> UITableViewCell {
        
        // we can still modify the cell as long as we fetch it from super
        let cell = super.tableView(tv, cellForRowAt:ix)
        
        // supply checkmarks as necessary
        let ud = UserDefaults.standard
        
        NSLog("about to update %@", cell.textLabel!.text!)
        cell.accessoryType = .none
        if let title = self.tableView(tv, titleForHeaderInSection:ix.section) {
            if let label = ud.object(forKey:title) as? String {
                if label == cell.textLabel!.text {
                    cell.accessoryType = .checkmark
                }
            }
        }
        return cell
    }
    
    func log(tv:UITableView, ip:IndexPath, phrase:String) {
        NSLog("%@", "========")
        NSLog("%@ %@", phrase, tv.cellForRow(at:ip)!.textLabel!.text!)
        NSLog("cell highlighted? %@", "\(tv.cellForRow(at:ip)!.isHighlighted)")
        NSLog("label highlighted? %@", "\(tv.cellForRow(at:ip)!.textLabel!.isHighlighted)")
    }
    
    override func tableView(_ tv: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        log(tv: tv, ip: indexPath, phrase: "should highlight")
        
        DispatchQueue.main.async {
            NSLog("%@", "callback from should highlight")
            }
        
        return true // try false to test this feature
    }
    
    override func tableView(_ tv: UITableView, didHighlightRowAt indexPath: IndexPath) {
        log(tv: tv, ip: indexPath, phrase: "did highlight")
    }
    
    override func tableView(_ tv: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        log(tv: tv, ip: indexPath, phrase: "did unhighlight")
        
        DispatchQueue.main.async {
            NSLog("%@", "callback from did unhighlight")
            }
    }
    
    override func tableView(_ tv: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        log(tv: tv, ip: indexPath, phrase: "will select")
        
        return indexPath
    }
    
    override func tableView(_ tv: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        log(tv: tv, ip: indexPath, phrase: "will deselect")
        
        return indexPath
    }
    
    override func tableView(_ tv: UITableView, didSelectRowAt ix: IndexPath) {
        log(tv: tv, ip: ix, phrase: "did select")
        
        let ud = UserDefaults.standard
        let setting = tv.cellForRow(at:ix)!.textLabel!.text
        let header = self.tableView(tv, titleForHeaderInSection:ix.section)!
        ud.setValue(setting, forKey:header)
        
        NSLog("%@", "about to reload!")
        tv.reloadData() // deselect all cells, reassign checkmark as needed

    }
    
    override func tableView(_ tv: UITableView, didDeselectRowAt indexPath: IndexPath) {
        NSLog("did deselect %@", tv.cellForRow(at:indexPath)!.textLabel!.text!)
    }
    
    // just proving this stuff works even in a grouped style table
    
    /*


    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        // v.backgroundColor = .yellow
        // tableView.backgroundColor = .green
        return v
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .blue
        return v
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

*/
    
}
