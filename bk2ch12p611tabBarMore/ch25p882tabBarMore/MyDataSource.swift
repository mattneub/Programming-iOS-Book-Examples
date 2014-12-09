

import UIKit

class MyDataSource: NSObject, UITableViewDataSource {
    var originalDataSource : UITableViewDataSource

    init(originalDataSource:UITableViewDataSource) {
        self.originalDataSource = originalDataSource
        super.init()
    }
    
    override func forwardingTargetForSelector(aSelector: Selector) -> AnyObject? {
        if self.originalDataSource.respondsToSelector(aSelector) {
            return self.originalDataSource
        }
        return super.forwardingTargetForSelector(aSelector)
    }
    
    func tableView(tv: UITableView, numberOfRowsInSection sec: Int) -> Int {
        // this is just to quiet the compiler
        return self.originalDataSource.tableView(tv, numberOfRowsInSection: sec)
    }
    
    func tableView(tv: UITableView, cellForRowAtIndexPath ip: NSIndexPath) -> UITableViewCell {
        // this is why we are here
        let cell = self.originalDataSource.tableView(tv, cellForRowAtIndexPath: ip)
        cell.textLabel!.font = UIFont(name: "GillSans-Bold", size: 14)!
        return cell
    }
   
}

