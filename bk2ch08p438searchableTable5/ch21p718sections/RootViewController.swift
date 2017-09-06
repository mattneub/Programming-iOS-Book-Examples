

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class MySearchController : UISearchController {
    deinit {
        print("farewell from search controller")
    }
}

class MySearchContainerViewController : UISearchContainerViewController {
    deinit {
        print("farewell from search container view controller")
    }
}

// Abandoned example, never got it to work satisfactorily, just looks like shit no matter what I try
// I don't understand how the Apple example is supposed to work


class RootViewController : UITableViewController, UISearchBarDelegate {
    struct Section {
        var sectionName : String
        var rowData : [String]
    }
    var sections : [Section]!
    // var searcher : UISearchController! // container will contain it
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let b = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(doSearch))
        self.navigationItem.rightBarButtonItem = b
    }
    
    @objc func doSearch(_ sender: Any) {
        // construct container view controller

        let src = SearchResultsController(data: self.sections)
        // instantiate a search controller and keep it alive
        let searcher = MySearchController(searchResultsController: src)
        src.searchController = searcher
        // specify who the search controller should notify when the search bar changes
        searcher.searchResultsUpdater = src
        searcher.hidesNavigationBarDuringPresentation = false
        searcher.obscuresBackgroundDuringPresentation = false
        searcher.searchBar.placeholder = "Search"
        searcher.searchBar.sizeToFit()
        

//        let vc = MySearchContainerViewController(searchController: searcher)
//        vc.title = "Search"
//        self.present(vc, animated: true)

        //        if #available(iOS 11.0, *) {
//            vc.navigationItem.searchController = searcher
//        } else {
//            // Fallback on earlier versions
//        }

//        searcher.searchBar.delegate = src
//        self.navigationController!.pushViewController(vc, animated:true)
//        let nav = UINavigationController(rootViewController: vc)
////        nav.modalTransitionStyle = .crossDissolve
//        self.present(nav, animated:true)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let s = try! String(
            contentsOfFile: Bundle.main.path(
                forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        let d = Dictionary(grouping: states) {String($0.prefix(1))}
        self.sections = Array(d).sorted{$0.key < $1.key}.map {
            Section(sectionName: $0.key, rowData: $0.value)
        }

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        
        self.tableView.sectionIndexColor = .white
        self.tableView.sectionIndexBackgroundColor = .red
        // self.tableView.sectionIndexTrackingBackgroundColor = .blue
        self.tableView.backgroundColor = .yellow // but the search bar covers that
        self.tableView.backgroundView = { // this will fix it
            let v = UIView()
            v.backgroundColor = .yellow
            return v
        }()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rowData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) 
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
    
    // this is more "interesting"
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView
            .dequeueReusableHeaderFooterView(withIdentifier:"Header")!
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
