
import UIKit

class RootViewController : UITableViewController {
    
    var sectionNames = [String]()
    var sectionData = [[String]]()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        let s = try! String(contentsOfFile: Bundle.main.pathForResource("states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = String(aState.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append( c.uppercased() )
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append( [String]() )
            }
            sectionData[sectionData.count-1].append( aState )
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        
        self.tableView.sectionIndexColor = UIColor.white()
        self.tableView.sectionIndexBackgroundColor = UIColor.red()
        self.tableView.sectionIndexTrackingBackgroundColor = UIColor.blue()
        
//        let b = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "doEdit:")
//        self.navigationItem.rightBarButtonItem = b
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem() // badda-bing, badda-boom
    }
    
//    func doEdit(_ sender:AnyObject?) {
//        var which : UIBarButtonSystemItem
//        if !self.tableView.editing {
//            self.tableView.setEditing(true, animated:true)
//            which = .Done
//        } else {
//            self.tableView.setEditing(false, animated:true)
//            which = .Edit
//        }
//        let b = UIBarButtonItem(barButtonSystemItem: which, target: self, action: "doEdit:")
//        self.navigationItem.rightBarButtonItem = b
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) 
        let s = self.sectionData[indexPath.section][indexPath.row]
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
            .dequeueReusableHeaderFooterView(withIdentifier:"Header")!
        if h.tintColor != UIColor.red() {
            h.tintColor = UIColor.red() // invisible marker, tee-hee
            h.backgroundView = UIView()
            h.backgroundView?.backgroundColor = UIColor.black()
            let lab = UILabel()
            lab.tag = 1
            lab.font = UIFont(name:"Georgia-Bold", size:22)
            lab.textColor = UIColor.green()
            lab.backgroundColor = UIColor.clear()
            h.contentView.addSubview(lab)
            let v = UIImageView()
            v.tag = 2
            v.backgroundColor = UIColor.black()
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
        lab.text = self.sectionNames[section]
        return h
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionNames
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt ip: IndexPath) {
        self.sectionData[ip.section].remove(at:ip.row)
        if self.sectionData[ip.section].count == 0 {
            self.sectionData.remove(at:ip.section)
            self.sectionNames.remove(at:ip.section)
            tableView.deleteSections(IndexSet(integer: ip.section),
                with:.automatic)
            tableView.reloadSectionIndexTitles()
        } else {
            tableView.deleteRows(at:[ip],
                with:.automatic)
        }
    }
    
    // prevent swipe-to-edit
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return self.isEditing ? .delete : .none
    }
    
}
