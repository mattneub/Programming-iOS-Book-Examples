

import UIKit

// how to get separator to run from edge to edge

class RootViewController: UITableViewController {
    
    // in iOS 10, title Test is indented by edge insets...
    // but separator runs from edge to edge because we set the cell separatorInset
    // explicitly for every *cell*
    
    // in iOS 11, separator behavior is a *table* property
    
    let cellID = "Cell"


    override func viewDidLoad() {
        super.viewDidLoad()
        let c = UITableViewCell()
        print(c.separatorInset)
        if #available(iOS 11.0, *) {
            let t = UITableView()
            print(t.separatorInsetReference.rawValue) // default is .fromCellEdges
            print(t.cellLayoutMarginsFollowReadableWidth)

            self.tableView.separatorInset = .zero
            // affects both content and separator inset? default is .fromCellEdge
            self.tableView.separatorInsetReference = .fromAutomaticInsets
            
            // affects content view separately from separator
            self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            self.tableView.insetsContentViewsToSafeArea = false
            
            self.tableView.cellLayoutMarginsFollowReadableWidth = true
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel!.text = "Test"
        
        cell.contentView.backgroundColor = .blue
        
        print(cell.separatorInset) // in iOS 11 this is already zero when we get here
        
        if #available(iOS 11.0, *) {
            if indexPath.row % 2 == 0 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            }
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
