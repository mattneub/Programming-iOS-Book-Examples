

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
    var searcher : UISearchController!
    
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
        self.tableView.backgroundView = {
            let v = UIView()
            v.backgroundColor = .yellow
            return v
            }()
        
        let src = SearchResultsController() // will configure later
        let searcher = MySearchController(searchResultsController: src)
        self.searcher = searcher
        self.searcher.delegate = self
        searcher.searchResultsUpdater = src
        // put the search controller's search bar into the interface
        let b = searcher.searchBar
        b.autocapitalizationType = .none
        // I'm forced to give up on this example in iOS 11
        // the search bar appears messed up in the search interface
        // however, I demonstrate use of scope button titles in nav bar later
        // oooh, news flash, this example works again (starting iOS 11.3?)
        // so for iOS 12 book the example is back
        b.scopeButtonTitles = ["Starts", "Contains"]
        // b.showsScopeBar = false // prevent showing in the table, but not needed
        b.sizeToFit()
        b.delegate = src
        self.tableView.tableHeaderView = b
        
        
        // another failed experiment...
//        let hfv = UITableViewHeaderFooterView()
//        hfv.contentView.addSubview(b)
//        hfv.bounds.size.height = b.bounds.height
//        self.tableView.tableHeaderView = hfv
//        NSLayoutConstraint.activate([
//            b.topAnchor.constraint(equalTo:hfv.contentView.topAnchor),
//            b.bottomAnchor.constraint(equalTo:hfv.contentView.bottomAnchor),
//            b.leadingAnchor.constraint(equalTo:hfv.contentView.leadingAnchor),
//            b.trailingAnchor.constraint(equalTo:hfv.contentView.trailingAnchor),
//        ])
        
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
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sections.map{$0.sectionName}
    }
}

extension RootViewController : UISearchControllerDelegate {
    // proving that we can configure at presentation time
    // there are two alternative ways to proceed
    // *either* you present yourself, in `presentSearchController`...
    // *or* you implement willPresent etc.
    func willPresentSearchController(_ sc: UISearchController) {
        if let src = sc.searchResultsController as? SearchResultsController {
            src.take(data:self.sections)
        }
    }
    /*
    func presentSearchController(_ sc: UISearchController) {
        self.present(sc, animated: true)
    }
 */
}

