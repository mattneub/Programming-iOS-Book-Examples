

import UIKit

class RootViewController : UITableViewController, UITextFieldDelegate {
    var name = ""
    var numbers = [String]()
    
    let cellID = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.name = "Matt Neuburg"
        self.numbers = ["(123) 456-7890"]
        self.tableView.allowsSelection = false
        
        self.tableView.register(UINib(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: self.cellID)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.numbers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID,
            for: indexPath) as! MyCell
        
        switch indexPath.section {
        case 0:
            cell.textField.text = self.name
        case 1:
            cell.textField.text = self.numbers[indexPath.row]
            cell.textField.keyboardType = .numbersAndPunctuation
        default: break
        }
        cell.textField.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 1 {
            let ct = self.tableView(tableView, numberOfRowsInSection:indexPath.section)
            if ct-1 == indexPath.row {
                return .insert
            }
            return .delete;
        }
        return .none
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        if section == 0 {
            return "Name"
        }
        return "Number"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // some cell's text field has finished editing; which cell?
        var v : UIView = textField
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! MyCell
        // update data model to match
        let ip = self.tableView.indexPath(for:cell)!
        if ip.section == 1 {
            self.numbers[ip.row] = cell.textField.text!
        } else if ip.section == 0 {
            self.name = cell.textField.text!
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let s = self.numbers.remove(at:fromIndexPath.row)
        self.numbers.insert(s, at:toIndexPath.row)
        tableView.reloadData() // to get plus and minus buttons to redraw themselves
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        tableView.endEditing(true)
        if proposedDestinationIndexPath.section == 0 {
            return IndexPath(row:0, section:1)
        }
        return proposedDestinationIndexPath
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 && self.numbers.count > 1 {
            return true
        }
        return false
    }
    
    override func tableView(_ tv: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt ip: IndexPath) {
        tv.endEditing(true) // user can click minus/plus while still editing
        // so we must force saving to the model
        if editingStyle == .insert {
            self.numbers += [""]
            let ct = self.numbers.count
            if #available(iOS 11.0, *) {
                tv.performBatchUpdates({
                    tv.insertRows(at:
                        [IndexPath(row:ct-1, section:1)], with:.automatic)
                    tv.reloadRows(at:
                        [IndexPath(row:ct-2, section:1)], with:.automatic)
                }) { _ in
                    let cell = self.tableView.cellForRow(at:
                        IndexPath(row:ct-1, section:1))
                    (cell as! MyCell).textField.becomeFirstResponder()
                }
            } else {
                tv.beginUpdates()
                tv.insertRows(at:
                    [IndexPath(row:ct-1, section:1)],
                                     with:.automatic)
                tv.reloadRows(at:
                    [IndexPath(row:ct-2, section:1)],
                                     with:.automatic)
                tv.endUpdates()
                // crucial that this next bit be *outside* the updates block
                let cell = self.tableView.cellForRow(at:
                    IndexPath(row:ct-1, section:1))
                (cell as! MyCell).textField.becomeFirstResponder()
            }
        }
        if editingStyle == .delete {
            
            self.numbers.remove(at:ip.row)

            if #available(iOS 11.0, *) {
                tv.performBatchUpdates({
                    tv.deleteRows(at:[ip], with:.automatic)
                    // if we omit reload, we get weird constraints errors
                    tv.reloadSections(IndexSet(integer:1), with:.automatic)
                })
            } else {
                tv.beginUpdates()
                tv.deleteRows(at:
                    [ip], with:.automatic)
                tv.reloadSections(
                    IndexSet(integer:1), with:.automatic)
                tv.endUpdates()
            }
            
        }
    }
    
}
