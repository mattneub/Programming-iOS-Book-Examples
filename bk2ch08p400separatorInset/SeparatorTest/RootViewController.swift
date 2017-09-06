

import UIKit

// how to get separator to run from edge to edge

class RootViewController: UITableViewController {
    
    // in iOS 10, title Test is indented by edge insets...
    // but separator runs from edge to edge because we set the cell separatorInset
    // explicitly for every *cell*
    
    // in iOS 11, separator behavior is a *table* property

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.tableView.separatorInset = .zero
            // no means no:
            self.tableView.separatorInsetReference = .fromCellEdges
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        cell.textLabel!.text = "Test"
        
        print(cell.separatorInset) // in iOS 11 this is already zero when we get here
        
        if #available(iOS 11.0, *) {
        } else {
            cell.separatorInset = .zero
        }
        
        // NO! they fixed this too
//        cell.layoutMargins = .zero
        
        // NO! They fixed this!!!!! No need for this trick any longer
        //cell.preservesSuperviewLayoutMargins = false
        
//        let cell2 = UITableViewCell()
//        print(cell2.separatorInset)
        
        //print(cell.separatorInset)

        return cell
    }


}
