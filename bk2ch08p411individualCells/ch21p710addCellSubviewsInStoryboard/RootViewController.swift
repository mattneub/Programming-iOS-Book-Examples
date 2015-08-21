
import UIKit

class RootViewController : UITableViewController {
    
    var cells = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        self.tableView.rowHeight = 58 // *
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000 // make a lot of rows this time!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as! MyCell

        let lab = cell.theLabel
        // prove that many rows does not mean many cell objects
        lab.text = "Row \(indexPath.row) of section \(indexPath.section)"
        if lab.tag != 999 {
            lab.tag = 999
            print("New cell \(++self.cells)")
        }

        
        let iv = cell.theImageView
        // shrink apparent size of image
        let im = UIImage(named:"moi.png")!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36,36), true, 0.0)
        im.drawInRect(CGRectMake(0,0,36,36))
        let im2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        iv.image = im2
        iv.contentMode = .Center

        
        return cell
    }
    
    

}