

import UIKit

protocol SizeDelegate : class {
    var selectedText : String {get set}
}

class TableViewController: UITableViewController {
    
    var selectedSize : String?
    weak var delegate : SizeDelegate?
    
    let cellID = "Cell"
        
    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.isScrollEnabled = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)

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
        
        cell.accessoryType = (cell.textLabel!.text == self.selectedSize) ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)!
        let s = cell.textLabel!.text!
        self.selectedSize = s
        self.delegate?.selectedText = s
        tableView.reloadData()
    }
    
}
