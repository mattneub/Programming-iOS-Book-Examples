

import UIKit

// couldn't get this to compile because of bug in Swift 3
// worked around that by making ourselves a UITableViewController subclass
// need to undo that when they get this working correctly

class MyDataSource: UITableViewController /* NSObject, UITableViewDataSource */ {
    var originalDataSource : UITableViewDataSource

    init(originalDataSource:UITableViewDataSource) {
        self.originalDataSource = originalDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func forwardingTarget(for aSelector: Selector) -> AnyObject? {
        if self.originalDataSource.responds(to:aSelector) {
            return self.originalDataSource
        }
        return super.forwardingTarget(for:aSelector)
    }
    
    override func tableView(_ tv: UITableView, numberOfRowsInSection sec: Int) -> Int {
        // this is just to quiet the compiler
        return self.originalDataSource.tableView(tv, numberOfRowsInSection: sec)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        // this is why we are here
        let cell = self.originalDataSource.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel!.font = UIFont(name: "GillSans-Bold", size: 14)!
        return cell
    }
   
}

