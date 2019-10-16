

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class MyHeaderView : UITableViewHeaderFooterView {
    var section = 0
    // just testing reuse
    deinit {
        print ("farewell from a header, section \(section)")
    }
}

class RootViewController : UITableViewController {
    struct Section {
        var sectionName : String
        var rowData : [String]
    }
    var sections : [Section]!
    var hiddenSections = Set<Int>()
    
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
        self.tableView.register(
            MyHeaderView.self, forHeaderFooterViewReuseIdentifier: self.headerID) //*
        
        self.tableView.sectionIndexColor = .white
        self.tableView.sectionIndexBackgroundColor = .red
        self.tableView.sectionIndexTrackingBackgroundColor = .blue
        return; // just testing reuse
        delay(5) {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections.contains(section) { // *
            return 0
        }
        return self.sections[section].rowData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let s = self.sections[indexPath.section].rowData[indexPath.row]
        cell.textLabel!.text = s
        
        // this part is not in the book, it's just for fun
        var stateName = s
        stateName = stateName.lowercased()
        stateName = stateName.replacingOccurrences(of:" ", with:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        cell.imageView!.image = im
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: self.headerID) as! MyHeaderView
        if h.gestureRecognizers == nil {
            print("nil")
            // add tap g.r.
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped)) // *
            tap.numberOfTapsRequired = 2 // *
            h.addGestureRecognizer(tap) // *

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
        h.section = section // *
        return h
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sections.map{$0.sectionName}
    }
    
    @objc func tapped (_ g : UIGestureRecognizer) {
        let v = g.view as! MyHeaderView
        let sec = v.section
        let ct = self.sections[sec].rowData.count
        let arr = (0..<ct).map {IndexPath(row:$0, section:sec)}
        if #available(iOS 11.0, *) {
            if self.hiddenSections.contains(sec) {
                self.hiddenSections.remove(sec)
                self.tableView.performBatchUpdates({
                    self.tableView.insertRows(at:arr, with:.automatic)
                }) { _ in
                    // improvement: make sure first inserted row is showing
                    self.tableView.scrollToRow(at:arr[0], at:.none, animated:true)
                }
            } else {
                self.hiddenSections.insert(sec)
                self.tableView.performBatchUpdates({
                    self.tableView.deleteRows(at:arr, with:.automatic)
                }) { _ in
                    // improvement: make sure removed section doesn't vanish off top
                    let rect = self.tableView.rect(forSection: sec)
                    self.tableView.scrollRectToVisible(rect, animated: true)
                }
            }
        } else {
            if self.hiddenSections.contains(sec) {
                self.hiddenSections.remove(sec)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at:arr, with:.automatic)
                self.tableView.endUpdates()
                self.tableView.scrollToRow(at:arr[ct-1], at:.none, animated:true)
            } else {
                self.hiddenSections.insert(sec)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at:arr, with:.automatic)
                self.tableView.endUpdates()
            }
        }

    }
}
