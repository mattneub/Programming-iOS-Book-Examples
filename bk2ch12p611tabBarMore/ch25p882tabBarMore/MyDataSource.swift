

import UIKit

class MyDataSource: NSObject, UITableViewDataSource {
    var originalDataSource : UITableViewDataSource

    init(originalDataSource:UITableViewDataSource) {
        self.originalDataSource = originalDataSource
    }
        
    override func forwardingTarget(for aSelector: Selector) -> Any? {
        if self.originalDataSource.responds(to:aSelector) {
            return self.originalDataSource
        }
        return super.forwardingTarget(for:aSelector)
    }
    
    func tableView(_ tv: UITableView, numberOfRowsInSection sec: Int) -> Int {
        // this is just to quiet the compiler
        return self.originalDataSource.tableView(tv, numberOfRowsInSection: sec)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // this is why we are here
        let cell = self.originalDataSource.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel!.font = UIFont(name: "GillSans-Bold", size: 14)!
        return cell
    }
   
}

