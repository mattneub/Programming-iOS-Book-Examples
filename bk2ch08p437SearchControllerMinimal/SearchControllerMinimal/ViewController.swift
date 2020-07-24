

import UIKit

class ViewController: UIViewController {
    var sc : UISearchController?
    override var prefersStatusBarHidden: Bool { true }
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc2 = ViewController2()
        let sc = UISearchController(searchResultsController: vc2)
        self.sc = sc
        sc.searchResultsUpdater = vc2
        let sb = sc.searchBar
        self.view.addSubview(sb)
    }
}
class ViewController2: UIViewController, UISearchResultsUpdating {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else {return}
        if let t = searchController.searchBar.text, !t.isEmpty {
            print("You are searching for", t)
        }
    }
}

