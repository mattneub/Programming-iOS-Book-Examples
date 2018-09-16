

import UIKit

class SearchResultsController : UITableViewController {
    var originalData = [String]()
    var filteredData = [String]()
    weak var searchController : UISearchController?
        
    func take(data:[RootViewController.Section]) {
        // we don't use sections, so flatten the data into a single array of strings
        self.originalData = data.map{$0.rowData}.flatMap{$0}
    }
    
    let cellID = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("src view did load")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        
        // we are now in total charge of the interface...
        // ... so make room for the tall search bar
//        self.tableView.contentInset = UIEdgeInsetsMake(90, 0, 0, 0)
//        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
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

extension SearchResultsController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("update")
        self.searchController = searchController // keep a weak ref just in case
        let sb = searchController.searchBar
        let target = sb.text!
        self.filteredData = self.originalData.filter { s in
            var options = String.CompareOptions.caseInsensitive
            // we now have scope buttons; 0 means "starts with"
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                options.insert(.anchored)
            }
            let found = s.range(of:target, options: options)
            return (found != nil)
        }
        self.tableView.reloadData()
    }
}

extension SearchResultsController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("button")
        self.updateSearchResults(for:self.searchController!)
    }
}
