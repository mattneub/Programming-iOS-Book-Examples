

import UIKit

protocol SizeDelegate : class {
    var selectedText : String {get set}
}

class TableViewController: UITableViewController {
    
    var selectedSize : String?
    weak var delegate : SizeDelegate?
        
    override func viewDidLoad() {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.scrollEnabled = false
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel!.text = {
            switch indexPath.row {
            case 0:
                return "Large"
            case 1:
                return "Medium"
            case 2:
                return "Small"
            default:
                return ""
            }
        }()
        
        cell.accessoryType = (cell.textLabel!.text == self.selectedSize) ? .Checkmark : .None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let s = cell.textLabel!.text!
        self.selectedSize = s
        self.delegate?.selectedText = s
        tableView.reloadData()
    }
    
}
