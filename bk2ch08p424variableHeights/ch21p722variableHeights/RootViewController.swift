

import UIKit

class Cell : UITableViewCell {
    @IBOutlet weak var lab : UILabel!
}

class RootViewController : UITableViewController {
    var trivia : [String]!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    let cellID = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = Bundle.main.url(forResource:"trivia", withExtension: "txt")
        let s = try! String(contentsOf:url!)
        let arr = s.components(separatedBy:"\n")
        self.trivia = Array(arr.dropLast())
        
        self.tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: self.cellID)
        // both these lines are needed
        self.tableView.rowHeight = UITableView.automaticDimension
        // what's new in iOS 11 is that you don't even have to supply an estimated height!
        // it too can be automatic
        if #available(iOS 11.0, *) {
            self.tableView.estimatedRowHeight = UITableView.automaticDimension
            // self.tableView.estimatedRowHeight = 40
            print(self.tableView.estimatedRowHeight)
        } else {
            self.tableView.estimatedRowHeight = 40
        }
        // basically, if the estimated height is zero, you have opted _out_ of variable height
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trivia.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! Cell
        cell.backgroundColor = .white
        cell.lab.text = self.trivia[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at:indexPath, animated:false)
            return nil
        }
        return indexPath
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        // return 30
//        print("here")
//        return UITableView.automaticDimension
//    }
//
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 0
////        return 100
//        return UITableView.automaticDimension
//    }
    
}
