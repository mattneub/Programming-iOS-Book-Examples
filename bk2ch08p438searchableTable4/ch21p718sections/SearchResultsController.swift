

import UIKit
import Swift

class SearchResultsController : UIViewController {
    let child : ChildViewController // a UITableViewController
    init(data:[[String]]) {
        self.child = ChildViewController(data:data)
        super.init(nibName:nil, bundle:nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = .clear
        self.addChildViewController(self.child)
        let v = self.child.view!
        self.view.addSubview(self.child.view)
        v.layer.cornerRadius = 15
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.heightAnchor.constraint(equalToConstant:400),
            v.widthAnchor.constraint(equalToConstant:400),
            v.topAnchor.constraint(equalTo:self.view.topAnchor, constant: 50),
            v.centerXAnchor.constraint(equalTo:self.view.centerXAnchor)
        ])
        self.child.didMove(toParentViewController: self)
        let t = UITapGestureRecognizer(target: self, action: #selector(tap))
        t.delegate = self
        self.view.addGestureRecognizer(t)
    }
}
extension SearchResultsController : UISearchResultsUpdating {
    func updateSearchResults(for sc: UISearchController) {
        self.child.updateSearchResults(for:sc)
    }
}
extension SearchResultsController : UIGestureRecognizerDelegate {
    func tap(_ g:UITapGestureRecognizer) {
        // find the UISearchController and dismiss it
        var r : UIResponder = g.view!
        while !(r is UISearchController) {r = r.next!}
        (r as! UISearchController).isActive = false
    }
    func gestureRecognizerShouldBegin(_ g: UIGestureRecognizer) -> Bool {
        // do nothing if the tap was in the table view
        let pt = g.location(ofTouch:0, in: self.child.view)
        if self.child.tableView.point(inside:pt, with: nil) {
            return false
        }
        return true
    }
}


class ChildViewController : UITableViewController {
    var originalData : [String]
    var filteredData = [String]()
    
    init(data:[[String]]) {
        // we don't use sections, so flatten the data into a single array of strings
        self.originalData = data.flatMap{$0}
        super.init(nibName: nil, bundle: nil)
        // self.preferredContentSize = CGSize(300,400)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    // all boilerplate; note that our data is _filteredData_, which is initially empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) 
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

extension ChildViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // print("here \(searchController.presentationController!.adaptivePresentationStyle().rawValue)")
        let sb = searchController.searchBar
        let target = sb.text!
        self.filteredData = self.originalData.filter {
            s in
            let found = s.range(of:target, options: .caseInsensitive)
            return (found != nil)
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
