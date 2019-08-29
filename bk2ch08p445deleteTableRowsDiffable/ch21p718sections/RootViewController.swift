
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

extension NSDiffableDataSourceSnapshot {
    mutating func deleteWithSections(_ items : [ItemIdentifierType]) {
        self.deleteItems(items)
        let empties = self.sectionIdentifiers.filter {
            self.numberOfItems(inSection: $0) == 0
        }
        self.deleteSections(empties)
    }
}

class MyDataSource : UITableViewDiffableDataSource<String,String> {
    override func sectionIndexTitles(for tv: UITableView) -> [String]? {
        let snap = self.snapshot()
        return snap.sectionIdentifiers
    }
    // need this or the index does nothing when tapped
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let snap = self.snapshot()
        return snap.indexOfSection(title) ?? 0
    }
    // need this or we can't move into edit mode
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        if let id = self.itemIdentifier(for: indexPath) {
            var snap = self.snapshot()
            snap.deleteWithSections([id])
            self.apply(snap)
        }
    }
    // movability, hmm rather clumsy this
    override func tableView(_ tableView: UITableView, canMoveRowAt ip: IndexPath) -> Bool {
        let id = self.itemIdentifier(for: ip)!
        let snap = self.snapshot()
        let sec = snap.sectionIdentifier(containingItem: id)!
        let ct = snap.numberOfItems(inSection: sec)
        return ct > 1
    }

    override func tableView(_ tableView: UITableView, moveRowAt srcip: IndexPath, to destip: IndexPath) {
        let src = self.itemIdentifier(for: srcip)!
        let dest = self.itemIdentifier(for: destip)!
        var snap = self.snapshot()
        // really a pity we have to do this before/after stuff
        if snap.indexOfItem(src)! > snap.indexOfItem(dest)! {
            snap.moveItem(src, beforeItem:dest)
        } else {
            snap.moveItem(src, afterItem:dest)
        }
        self.apply(snap, animatingDifferences: false)
    }
}

class RootViewController : UITableViewController {
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    let cellID = "Cell"
	let headerID = "Header"
    
    lazy var datasource = MyDataSource(tableView:self.tableView) {
        tv, ip, s in
        let cell = tv.dequeueReusableCell(withIdentifier: self.cellID, for: ip)
        cell.textLabel!.text = s
        
        var stateName = s
        stateName = stateName.lowercased()
        stateName = stateName.replacingOccurrences(of:" ", with:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        cell.imageView!.image = im
        
        return cell
    }
    
    override func viewDidLoad() {
        let s = try! String(
            contentsOfFile: Bundle.main.path(
                forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        let d = Dictionary(grouping: states) {String($0.prefix(1))}
//        self.sections = Array(d).sorted{$0.key < $1.key}.map {
//            Section(sectionName: $0.key, rowData: $0.value)
//        }
        let sections = Array(d).sorted{$0.key < $1.key}
        var snap = NSDiffableDataSourceSnapshot<String,String>()
        for section in sections {
            snap.appendSections([section.0])
            // no need to say this
            // snap.appendItems(section.1, toSection:section.0)
            snap.appendItems(section.1)
        }
        self.datasource.apply(snap, animatingDifferences: false)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        
        self.tableView.sectionIndexColor = .white
        self.tableView.sectionIndexBackgroundColor = .red
        self.tableView.sectionIndexTrackingBackgroundColor = .blue
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // oddly, this is legal
//        self.tableView.allowsSelection = false
//        self.tableView.allowsMultipleSelection = true
        
        // return;
        // this pair of lines suppresses the whole Minus button thing
        // replacing it with circle and checkmark
        // they have to _both_ be true to do that
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        // *
        self.datasource.defaultRowAnimation = .left // makes all the deletions look better
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
        // this is why we are here!
        guard let sel = self.tableView.indexPathsForSelectedRows else {return}
        let rowids = sel.map {self.datasource.itemIdentifier(for: $0)}.compactMap {$0}
        var snap = self.datasource.snapshot()
        snap.deleteWithSections(rowids)
        self.datasource.apply(snap)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated:animated)
        if !self.isEditing {
            self.navigationItem.leftBarButtonItem = nil
        }
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
        // *
        lab.text = self.datasource.snapshot().sectionIdentifiers[section]
        return h
    }
            
    /*
        
    // prevent swipe-to-edit
    
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//            return tableView.isEditing ? .delete : .none
//    }
     
     */
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt srcip: IndexPath, toProposedIndexPath destip: IndexPath) -> IndexPath {
        if destip.section != srcip.section {
            return srcip
        }
        return destip
    }
    
}
