

import UIKit

class MySearchController : UISearchController {
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

class RootViewController : UITableViewController, UISearchBarDelegate {
    struct Section {
        var sectionName : String
        var rowData : [String]
    }
    var sections : [Section]!

    var originalSections : [Section]!
    
    var searcher : UISearchController!
    var searching = false
    
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
        // self.tableView.sectionIndexTrackingBackgroundColor = .blue
        // self.tableView.backgroundColor = .yellow
        self.tableView.backgroundView = { // this will fix it
            let v = UIView()
            v.backgroundColor = .yellow
            return v
            }()
        
        // in this version, we take the total opposite approach:
        // we don't present any extra view at all!
        // we already have a table, so why not just filter the very same table?
        // to do so, pass nil as the search results controller,
        // and tell the search controller not to insert a dimming view
        
        let searcher = MySearchController(searchResultsController:nil)
        self.searcher = searcher
        searcher.obscuresBackgroundDuringPresentation = false
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
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    // much nicer without section index during search
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.searching ? nil : self.sections.map{$0.sectionName}
    }
}

extension RootViewController : UISearchControllerDelegate {
    // flag for whoever needs it (in this case, sectionIndexTitles...)
    func willPresentSearchController(_ searchController: UISearchController) {
        self.originalSections = self.sections // keep copy of the original data
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
            self.sections = self.originalSections
        } else {
            self.sections = self.originalSections.reduce(into:[Section]()) {acc, sec in
                let rowData = sec.rowData.filter {
                    $0.range(of:target, options: .caseInsensitive) != nil
                }
                if rowData.count > 0 {
                    acc.append(Section(sectionName: sec.sectionName, rowData: rowData))
                }
            }
        }
        self.tableView.reloadData()
    }
}

