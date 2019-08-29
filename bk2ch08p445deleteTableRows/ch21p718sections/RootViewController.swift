
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class RootViewController : UITableViewController {
    
    struct Section {
        var sectionName : String
        var rowData : [String]
    }
    var sections : [Section]!

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    let cellID = "Cell"
	let headerID = "Header"
    
    override func viewDidLoad() {
        let s = try! String(
            contentsOfFile: Bundle.main.path(
                forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        let d = Dictionary(grouping: states) {String($0.prefix(1))}
        self.sections = Array(d).sorted{$0.key < $1.key}.map {
            Section(sectionName: $0.key, rowData: $0.value)
        }

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        
        self.tableView.sectionIndexColor = .white
        self.tableView.sectionIndexBackgroundColor = .red
        self.tableView.sectionIndexTrackingBackgroundColor = .blue
        
        var which : Int { return 1 } // 0 for manual, 1 for built-in edit button
        switch which {
        case 0:
            let b = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(doEdit))
            self.navigationItem.rightBarButtonItem = b
        case 1:
            self.navigationItem.rightBarButtonItem = self.editButtonItem // badda-bing, badda-boom
        default:break
        }
        
        // oddly, this is legal
//        self.tableView.allowsSelection = false
//        self.tableView.allowsMultipleSelection = true
        
        // return;
        // this pair of lines suppresses the whole Minus button thing
        // replacing it with circle and checkmark
        // they have to _both_ be true to do that
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        print("should begin multiple?")
        // return false
        // otherwise edit toggle comes unstuck
        self.setEditing(true, animated: true)
        return true
    }
    
    override func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        print("did begin multiple")
    }
    
    override func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        print("did end multiple")
        let sel = tableView.indexPathsForSelectedRows
        if sel == nil {
            self.navigationItem.leftBarButtonItem = nil
        } else {
            let bbi = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(doDeleteSelected))
            self.navigationItem.leftBarButtonItem = bbi
        }
    }
    
    @objc func doDeleteSelected(_ sender:Any) {
        guard let sel = self.tableView.indexPathsForSelectedRows else {return}
        self.tableView.performBatchUpdates({
            for ip in sel.sorted().reversed() {
                self.sections[ip.section].rowData.remove(at:ip.row)
            }
            self.tableView.deleteRows(at:sel, with: .automatic)
            let secs = self.sections.indices.filter {
                self.sections[$0].rowData.count == 0
            }
            for sec in secs.reversed() {
                self.sections.remove(at:sec)
            }
            self.tableView.deleteSections(IndexSet(secs), with: .fade)
        })
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated:animated)
        if !self.isEditing {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    @objc func doEdit(_ sender: Any?) {
        var which : UIBarButtonItem.SystemItem
        if !self.tableView.isEditing {
            self.tableView.setEditing(true, animated:true)
            which = .done
        } else {
            self.tableView.setEditing(false, animated:true)
            which = .edit
        }
        let b = UIBarButtonItem(barButtonSystemItem: which, target: self, action: #selector(doEdit))
        self.navigationItem.rightBarButtonItem = b
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rowData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let s = self.sections[indexPath.section].rowData[indexPath.row]
        cell.textLabel!.text = s
        
        var stateName = s
        stateName = stateName.lowercased()
        stateName = stateName.replacingOccurrences(of:" ", with:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        cell.imageView!.image = im
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let h = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: self.headerID)!
        if h.viewWithTag(1) == nil {
            
            h.backgroundView = UIView()
            h.backgroundView?.backgroundColor = .black
            let lab = UILabel()
            lab.tag = 1
            lab.font = UIFont(name:"Georgia-Bold", size:22)
            lab.textColor = .green
            lab.backgroundColor = .clear
            h.contentView.addSubview(lab)
            let v = UIImageView()
            v.tag = 2
            v.backgroundColor = .black
            v.image = UIImage(named:"us_flag_small.gif")
            h.contentView.addSubview(v)
            lab.translatesAutoresizingMaskIntoConstraints = false
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:
                    "H:|-5-[lab(25)]-10-[v(40)]",
                    metrics:nil, views:["v":v, "lab":lab]),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:|[v]|",
                    metrics:nil, views:["v":v]),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:|[lab]|",
                    metrics:nil, views:["lab":lab])
                ].flatMap{$0})
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sections[section].sectionName
        return h
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sections.map{$0.sectionName}
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt ip: IndexPath) {
        // had to split into two batches on iOS 11, filed a bug about that
        // okay seems to be fixed in iOS 13, collapsing the code into one thing
        // (but try this in iOS 12, you'll see the problem)
        switch editingStyle {
        case .delete:
            tableView.performBatchUpdates({
                self.sections[ip.section].rowData.remove(at:ip.row)
                tableView.deleteRows(at:[ip], with: .automatic)
                if self.sections[ip.section].rowData.count == 0 {
                    self.sections.remove(at:ip.section)
                    tableView.deleteSections(
                        IndexSet(integer: ip.section), with:.fade)
                }
            })
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // if indexPath.row == 0 { return false }
        return true
    }
    
    // prevent swipe-to-edit
    
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//            return tableView.isEditing ? .delete : .none
//    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt ip: IndexPath) -> Bool {
        return self.sections[ip.section].rowData.count > 1
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt srcip: IndexPath, toProposedIndexPath destip: IndexPath) -> IndexPath {
        if destip.section != srcip.section {
            return srcip
        }
        return destip
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt srcip: IndexPath, to destip: IndexPath) {
        let sec = srcip.section
        let srcrow = srcip.row
        let destrow = destip.row
        self.sections[sec].rowData.swapAt(srcrow, destrow)
    }
    
}
