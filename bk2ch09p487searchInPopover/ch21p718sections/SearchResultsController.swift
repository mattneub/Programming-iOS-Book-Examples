

import UIKit

/*
No law whatever says that the search results controller must be a table view controller,
or that the search results must be shown in a table;
it's just a convenient thing to do.

This is the rock-bottom simplest implementation I could think of:
a default table with the search results in each cell's textLabel.
*/

class SearchResultsController : UITableViewController {
    var originalData : [String]
    var filteredData = [String]()
    
    init(data:[[String]]) {
        // we don't use sections, so flatten the data into a single array of strings
        var flattened = [String]()
        for arr in data {
            for s in arr {
                flattened += [s]
            }
        }
        self.originalData = flattened
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    // all boilerplate; note that our data is _filteredData_, which is initially empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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

/*
This is the only other interesting part!
We are the searchResultsUpdater, which simply means that our
updateSearchResultsForSearchController is called every time something happens
in the search bar. So, every time it is called,
filter the original data in accordance with what's in the search bar,
and reload the table.
*/

extension SearchResultsController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("update")
        let sb = searchController.searchBar
        let target = sb.text!
        self.filteredData = self.originalData.filter {
            s in
            let options = NSStringCompareOptions.CaseInsensitiveSearch
            let found = (s as NSString).rangeOfString(target, options: options).length
            return (found != 0)
        }
        self.tableView.reloadData()
    }
}

/*
We are not _doing_ anything with the search results.
We are not acting as the search controller's delegate.
We are not even bothering to be the search bar's delegate.
It's just a demonstration of super-basic use of a search controller.
*/