

import UIKit

class Cell : UITableViewCell {
    @IBOutlet var lab : UILabel
}

class RootViewController : UITableViewController {
    var trivia : String[]!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSBundle.mainBundle().URLForResource("trivia", withExtension: "txt")
        let s = String.stringWithContentsOfURL(url, encoding: NSUTF8StringEncoding, error: nil)
        var arr = s!.componentsSeparatedByString("\n")
        arr.removeLast()
        self.trivia = arr
        
        self.tableView.registerNib(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.rowHeight = UITableViewAutomaticDimension // not actually necessary
        self.tableView.estimatedRowHeight = 40 // turn on automatic cell variable sizing!
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.trivia.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as Cell
        cell.backgroundColor = UIColor.whiteColor()
        cell.lab.text = self.trivia[indexPath.row]
        return cell
    }
}