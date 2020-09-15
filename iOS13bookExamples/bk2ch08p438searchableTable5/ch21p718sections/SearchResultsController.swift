

import UIKit
import Swift

class SearchResultsController : UITableViewController {
    var originalData : [String]
    var filteredData = [String]()
    
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
        self.view.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isHidden = false
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
        
        self.view.isHidden = false
        
        let sb = searchController.searchBar
        let target = sb.text!
        self.filteredData = self.originalData.filter { s in
            let found = s.range(of:target, options: .caseInsensitive)
            return (found != nil)
        }
        self.tableView.reloadData()
    }
}

extension SearchResultsController : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true)
    }
}

