

import UIKit

class MyDataSource: NSObject, UITableViewDataSource {
    unowned let orig : UITableViewDataSource

    init(originalDataSource:UITableViewDataSource) {
        self.orig = originalDataSource
    }
        
    override func forwardingTarget(for aSelector: Selector) -> Any? {
        if self.orig.responds(to:aSelector) {
            return self.orig
        }
        return super.forwardingTarget(for:aSelector)
    }
    
    func tableView(_ tv: UITableView, numberOfRowsInSection sec: Int) -> Int {
        // this is just to quiet the compiler
        return self.orig.tableView(tv, numberOfRowsInSection: sec)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // this is why we are here
        let cell = self.orig.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel!.font = UIFont(name: "GillSans-Bold", size: 14)!
        return cell
    }
   
}

