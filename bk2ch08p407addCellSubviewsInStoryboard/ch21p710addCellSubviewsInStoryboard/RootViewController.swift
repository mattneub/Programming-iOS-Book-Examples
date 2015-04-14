
import UIKit

class RootViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.tableView.registerNib(UINib(nibName:"MyCell", bundle:nil), forCellReuseIdentifier: "Cell") // Don't register anything! But the cell id must match the storyboard
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        // self.tableView.rowHeight = 58 // *
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as! MyCell

        // can refer to subviews by their tags
        // subview positioning configured by constraints in the nib!
        
        let lab = cell.theLabel // *
        lab.text = "The author of this book, who would rather be out dirt biking"
        
        let iv = cell.theImageView // *
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