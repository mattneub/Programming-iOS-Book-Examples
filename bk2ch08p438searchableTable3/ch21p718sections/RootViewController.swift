

import UIKit

class MySearchController : UISearchController {
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

class RootViewController : UITableViewController, UISearchBarDelegate {
    var sectionNames = [String]()
    var sectionData = [[String]]()
    var originalSectionNames = [String]()
    var originalSectionData = [[String]]()
    var searcher : UISearchController!
    var searching = false
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        let s = try! String(contentsOfFile: Bundle.main.pathForResource("states", ofType: "txt")!, encoding: .utf8)
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
        // self.tableView.sectionIndexTrackingBackgroundColor = UIColor.blue()
        // self.tableView.backgroundColor = UIColor.yellow()
        self.tableView.backgroundView = { // this will fix it
            let v = UIView()
            v.backgroundColor = UIColor.yellow()
            return v
            }()
        
        // in this version, we take the total opposite approach:
        // we don't present any extra view at all!
        // we already have a table, so why not just filter the very same table?
        // to do so, pass nil as the search results controller,
        // and tell the search controller not to insert a dimming view
        
        // keep copies of the original data
        self.originalSectionData = self.sectionData
        self.originalSectionNames = self.sectionNames
        let searcher = MySearchController(searchResultsController:nil)
        self.searcher = searcher
        searcher.dimsBackgroundDuringPresentation = false
        searcher.searchResultsUpdater = self
        searcher.delegate = self
        // put the search controller's search bar into the interface
        let b = searcher.searchBar
        b.sizeToFit() // crucial, trust me on this one
        b.autocapitalizationType = .none
        self.tableView.tableHeaderView = b
        self.tableView.reloadData()
        self.tableView.scrollToRow(at:
            IndexPath(row: 0, section: 0),
            at:.top, animated:false)
    }
    
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
                ].flatten().map{$0})
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sectionNames[section]
        return h
    }
    
    // much nicer without section index during search
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.searching ? nil : self.sectionNames
    }
}

extension RootViewController : UISearchControllerDelegate {
    // flag for whoever needs it (in this case, sectionIndexTitles...)
    func willPresentSearchController(_ searchController: UISearchController) {
        self.searching = true
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        self.searching = false
    }
}

extension RootViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let sb = searchController.searchBar
        let target = sb.text!
        if target == "" {
            self.sectionNames = self.originalSectionNames
            self.sectionData = self.originalSectionData
            self.tableView.reloadData()
            return
        }
        // we have a target string
        self.sectionData = self.originalSectionData.map {
            $0.filter {
                let found = $0.range(of:target, options: .caseInsensitiveSearch)
                return (found != nil)
            }
        }.filter {$0.count > 0} // is Swift cool or what?
        self.sectionNames = self.sectionData.map {String($0[0].characters.prefix(1))}
        self.tableView.reloadData()
    }
}

