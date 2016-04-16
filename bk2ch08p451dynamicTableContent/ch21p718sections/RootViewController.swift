

import UIKit

func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class MyHeaderView : UITableViewHeaderFooterView {
    var section = 0
    // just testing reuse
    deinit {
        print ("farewell from a header, section \(section)")
    }
}

class RootViewController : UITableViewController {
    var sectionNames = [String]()
    var sectionData = [[String]]()
    var hiddenSections = Set<Int>()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        let s = try! String(contentsOfFile: NSBundle.main().pathForResource("states", ofType: "txt")!, encoding: NSUTF8StringEncoding)
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
        self.tableView.register(
            MyHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header") //*
        
        self.tableView.sectionIndexColor = UIColor.white()
        self.tableView.sectionIndexBackgroundColor = UIColor.red()
        self.tableView.sectionIndexTrackingBackgroundColor = UIColor.blue()
        return; // just testing reuse
        delay(5) {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections.contains(section) { // *
            return 0
        }
        return self.sectionData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        let s = self.sectionData[indexPath.section][indexPath.row]
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
            .dequeueReusableHeaderFooterView(withIdentifier:"Header") as! MyHeaderView
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
                    options:[], metrics:nil, views:["v":v, "lab":lab]),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:|[v]|",
                    options:[], metrics:nil, views:["v":v]),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:|[lab]|",
                    options:[], metrics:nil, views:["lab":lab])
                ].flatten().map{$0})
            // add tap g.r.
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped)) // *
            tap.numberOfTapsRequired = 2 // *
            h.addGestureRecognizer(tap) // *
        }
        let lab = h.contentView.withTag(1) as! UILabel
        lab.text = self.sectionNames[section]
        h.section = section // *
        return h
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionNames
    }
    
    func tapped (g : UIGestureRecognizer) {
        let v = g.view as! MyHeaderView
        let sec = v.section
        let ct = self.sectionData[sec].count
        let arr = (0..<ct).map {NSIndexPath(forRow:$0, inSection:sec)} // whoa! ***
        if self.hiddenSections.contains(sec) {
            self.hiddenSections.remove(sec)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at:arr,
                with:.automatic)
            self.tableView.endUpdates()
            self.tableView.scrollToRow(at:arr[ct-1],
                at:.none,
                animated:true)
        } else {
            self.hiddenSections.insert(sec)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at:arr,
                with:.automatic)
            self.tableView.endUpdates()
        }

    }
}
