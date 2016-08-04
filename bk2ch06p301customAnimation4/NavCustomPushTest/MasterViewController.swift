
import UIKit

class MasterViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let b = UIBarButtonItem(title: "Push", style: .plain, target: self, action: #selector(doPush))
        self.navigationItem.rightBarButtonItem = b
    }
    
    func doPush(_ sender:AnyObject?) {
        self.performSegue(withIdentifier:"showDetail", sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            (segue.destination as! DetailViewController).detailItem = Date()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
        guard let tc = self.transitionCoordinator else {return}
        guard tc.initiallyInteractive else {return}
        tc.notifyWhenInteractionChanges { // "changes" instead of "ends"
            context in
            if context.isCancelled {
                print("we got cancelled")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + #function)
        
        if let tc = self.transitionCoordinator {
            print(tc)
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
        
    }

    
}
