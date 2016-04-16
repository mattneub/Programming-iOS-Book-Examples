

import UIKit

func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class RootViewController: UITableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        cell.textLabel!.text = "Let’s go!"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        // there must be at least _some_ delay, to let the spinner start spinning
        // in this case I also use the delay to simulate a time-consuming preparation process
        delay (2) {
            let detail = ViewController()
            self.tableView.selectRow(at:nil, animated: false, scrollPosition: .none)
            self.navigationController!.pushViewController(detail, animated: true)
        }
    }

}
