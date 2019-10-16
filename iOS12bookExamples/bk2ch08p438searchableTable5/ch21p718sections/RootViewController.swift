

import UIKit

// no room for this one in the book
// based on https://stackoverflow.com/a/46283774/341994

// there is something skanky about the way this looks in iOS 12 anyway
// look at the funny movement of the insertion point into the search bar

class SearchContainerVC: UISearchContainerViewController {
    
    init(data:[RootViewController.Section]) {
        let src = SearchResultsController(data:data)
        let searcher = UISearchController(searchResultsController: src)
        super.init(searchController: searcher)
        
        searcher.searchResultsUpdater = src
        searcher.hidesNavigationBarDuringPresentation = false
        
        self.navigationItem.searchController = searcher
        
        let b = searcher.searchBar
        b.autocapitalizationType = .none
        b.delegate = src
        b.showsCancelButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white // ugly otherwise
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class RootViewController : UITableViewController, UISearchBarDelegate {
    struct Section {
        var sectionName : String
        var rowData : [String]
    }
    var sections : [Section]!
    
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
        self.tableView.backgroundColor = .yellow // but the search bar covers that
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(doSearch))
        
        self.tableView.reloadData()
        self.tableView.scrollToRow(at:
            IndexPath(row: 0, section: 0),
            at:.top, animated:false)
    }
    
    @objc func doSearch(_ sender : Any) {
        let vc = SearchContainerVC(data:self.sections)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
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
    
    /*
    
    override func tableView(_ tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
    return self.sectionNames[section]
    }
    
    */
    // this is more "interesting"
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
    
    /*
    override func tableView(_ tableView: UITableView!, willDisplayHeaderView view: UIView!, forSection section: Int) {
    println(view) // prove we are reusing header views
    }
    */
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sections.map{$0.sectionName}
    }
}

extension RootViewController : UISearchControllerDelegate {
}
