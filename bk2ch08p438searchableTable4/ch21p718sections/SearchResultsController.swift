

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
        self.view.backgroundColor = UIColor.clearColor()
        self.addChildViewController(self.child)
        let v = self.child.view
        self.view.addSubview(self.child.view)
        v.layer.cornerRadius = 15
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            v.heightAnchor.constraintEqualToConstant(400),
            v.widthAnchor.constraintEqualToConstant(400),
            v.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 50),
            v.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
        ])
        self.child.didMoveToParentViewController(self)
        let t = UITapGestureRecognizer(target: self, action: "tap:")
        t.delegate = self
        self.view.addGestureRecognizer(t)
    }
}
extension SearchResultsController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(sc: UISearchController) {
        self.child.updateSearchResultsForSearchController(sc)
    }
}
extension SearchResultsController : UIGestureRecognizerDelegate {
    func tap(g:UITapGestureRecognizer) {
        // find the UISearchController and dismiss it
        var r : UIResponder = g.view!
        while !(r is UISearchController) {r = r.nextResponder()!}
        (r as! UISearchController).active = false
    }
    func gestureRecognizerShouldBegin(g: UIGestureRecognizer) -> Bool {
        // do nothing if the tap was in the table view
        let pt = g.locationOfTouch(0, inView: self.child.view)
        if self.child.tableView.pointInside(pt, withEvent: nil) {
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
        self.originalData = data.flatten().map{$0}
        super.init(nibName: nil, bundle: nil)
        // self.preferredContentSize = CGSizeMake(300,400)
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

extension ChildViewController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // print("here \(searchController.presentationController!.adaptivePresentationStyle().rawValue)")
        let sb = searchController.searchBar
        let target = sb.text!
        self.filteredData = self.originalData.filter {
            s in
            let options = NSStringCompareOptions.CaseInsensitiveSearch
            let found = s.rangeOfString(target, options: options)
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