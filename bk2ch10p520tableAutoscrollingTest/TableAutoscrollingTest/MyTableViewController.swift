

import UIKit

class MyTableViewController: UITableViewController {
    
    // called at launch and after we click in a text field
    // only the adjustedContentInset changes
    // very mysterious: how is the table view able to change the
    // adjustedContentInset by itself when it isn't settable?
    
    override func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        print("did adjust")
        print("contentInset", self.tableView.contentInset)
        print("indicatorInsets", self.tableView.scrollIndicatorInsets)
        print("adjustedContentInsets", self.tableView.adjustedContentInset)
        print("safe area", self.tableView.safeAreaInsets)
        print("additional safe area", self.additionalSafeAreaInsets)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }

}
