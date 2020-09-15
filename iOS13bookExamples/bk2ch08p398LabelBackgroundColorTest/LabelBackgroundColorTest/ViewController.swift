
// run on both iOS 13 and iOS 12, the differences are amazing and confusing

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "howdy"
        if indexPath.row == 1 {
            cell.textLabel?.backgroundColor = .blue
        }
        return cell
    }
        


}

