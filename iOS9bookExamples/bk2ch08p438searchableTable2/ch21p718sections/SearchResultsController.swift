

import UIKit

class SearchResultsController : UITableViewController {
    var originalData = [String]()
    var filteredData = [String]()
    weak var searchController : UISearchController?
        
    func takeData(data:[[String]]) {
        // we don't use sections, so flatten the data into a single array of strings
        self.originalData = data.flatten().map{$0}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // we are now in total charge of the interface...
        // ... so make room for the tall search bar
        self.tableView.contentInset = UIEdgeInsetsMake(90, 0, 0, 0)
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        cell.textLabel!.text = self.filteredData[indexPath.row]
        return cell
    }
}

extension SearchResultsController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("update")
        self.searchController = searchController // keep a weak ref just in case
        let sb = searchController.searchBar
        let target = sb.text!
        self.filteredData = self.originalData.filter {
            s in
            var options = NSStringCompareOptions.CaseInsensitiveSearch
            // we now have scope buttons; 0 means "starts with"
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                options.insert(.AnchoredSearch)
            }
            let found = s.rangeOfString(target, options: options)
            return (found != nil)
        }
        self.tableView.reloadData()
    }
}

extension SearchResultsController : UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("button")
        self.updateSearchResultsForSearchController(self.searchController!)
    }
}
