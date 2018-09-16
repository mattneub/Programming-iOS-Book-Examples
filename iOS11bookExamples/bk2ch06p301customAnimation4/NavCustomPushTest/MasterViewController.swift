
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class MyCell : UITableViewCell {
    @IBOutlet weak var iv : UIImageView!
}

class MasterViewController : UITableViewController {
    
    let cellID = "Cell"
    
    struct CellModel {
        let name = "poppy" // hard-coded; well it's only an example
        var visible = true
    }
    
    var model = [CellModel()] // only one row; I _said_ it's only an example
    
    var lastSelection = IndexPath()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! MyCell
        let cm = self.model[indexPath.row]
        cell.iv.image = UIImage(named:cm.name)
        if !cm.visible {
            cell.iv.image = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.model[indexPath.row].visible = false
        tableView.reloadRows(at: [indexPath], with: .none)
        self.lastSelection = indexPath
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(self.tableView.indexPathForSelectedRow as Any)
        if let dest = segue.destination as? DetailViewController {
            let cm = self.model[self.lastSelection.row]
            dest.detailItem = UIImage(named:cm.name)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        func reset(_ cm : inout CellModel) {
            cm.visible = true
        }
        for ix in self.model.indices {reset(&self.model[ix])}
        self.tableView.reloadData()
        
        // rest is just interesting logging
        
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
        
        // to see this, turn off our animation and use the pop gesture
        let tc = self.transitionCoordinator
        tc?.notifyWhenInteractionChanges { ctx in
            if ctx.isCancelled {
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
