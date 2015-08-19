

import UIKit

// Not in book: how to get separator to run from edge to edge

class RootViewController: UITableViewController {


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = "Test"
        
        // must set all three of these:
        print(cell.separatorInset)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        // NO! They fixed this!!!!! No need for this trick any longer
        //cell.preservesSuperviewLayoutMargins = false
        
//        let cell2 = UITableViewCell()
//        print(cell2.separatorInset)
        
        //print(cell.separatorInset)

        return cell
    }


}
