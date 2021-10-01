

import UIKit

class RootViewController : UITableViewController {
    
    lazy var datasource = MyDataSource(tableView: self.tableView)

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self.datasource
    }
    
}
