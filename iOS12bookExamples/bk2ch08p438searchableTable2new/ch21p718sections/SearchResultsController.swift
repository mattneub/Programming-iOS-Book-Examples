

import UIKit
import Swift

class SearchResultsController : UITableViewController {
    var originalData : [String]
    var filteredData = [String]()
    
    weak var searchBar : UISearchBar!
    
    init(data:[RootViewController.Section]) {
        // we don't use sections, so flatten the data into a single array of strings
        self.originalData = data.map{$0.rowData}.flatMap{$0}
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    let cellID = "Cell"
    
    // all boilerplate; note that our data is _filteredData_, which is initially empty
    
    lazy var seg : UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Contains", "Starts With"])
        seg.sizeToFit()
        seg.selectedSegmentIndex = 0
        seg.addTarget(self, action: #selector(scopeChanged), for: .primaryActionTriggered)
        return seg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.tableHeaderView = self.seg
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isHidden = false
        print("appear")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel!.text = self.filteredData[indexPath.row]
        return cell
    }
}

/*
This is the only other interesting part!
We are the searchResultsUpdater, which simply means that our
updateSearchResultsForSearchController is called every time something happens
in the search bar. So, every time it is called,
filter the original data in accordance with what's in the search bar,
and reload the table.
*/

extension SearchResultsController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("update search results")
        self.view.isHidden = false // *
        self.searchBar = searchController.searchBar
        self.doUpdate()
    }
    func doUpdate() {
        let target = self.searchBar.text!
        self.filteredData = self.originalData.filter { s in
            var options = String.CompareOptions.caseInsensitive
            if self.seg.selectedSegmentIndex == 1 { // 1 means "starts with"
                options.insert(.anchored)
            }
            let found = s.range(of:target, options: options)
            return (found != nil)
        }
        self.tableView.reloadData()
    }
    @objc func scopeChanged(_ sender : UISegmentedControl) {
        self.doUpdate()
    }
}


/*
We are not _doing_ anything with the search results.
We are not acting as the search controller's delegate.
We are not even bothering to be the search bar's delegate.
It's just a demonstration of super-basic use of a search controller.
*/
