

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
        
    // all boilerplate; note that our data is _filteredData_, which is initially empty
    
    let cellID = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
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

extension SearchResultsController : UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchBar = searchController.searchBar
        self.doUpdate()
    }
    func doUpdate() {
        let target = self.searchBar.text!
        self.filteredData = self.originalData.filter { s in
            var options = String.CompareOptions.caseInsensitive
            if self.searchBar.selectedScopeButtonIndex == 0 { // 0 means "starts with"
                options.insert(.anchored)
            }
            let found = s.range(of:target, options: options)
            return (found != nil)
        }
        self.tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar,
                   selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.doUpdate()
    }
}


