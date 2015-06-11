
import UIKit

class RootViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(MyCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        self.tableView.rowHeight = 58
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    /*
    As promised, the cell will never be nil and doesn't need to be an Optional.
    But we must find another test to decide whether initial configuration is needed
    (i.e. is this a blank empty new cell or is it reused, so that it was configured
    in a previous call to cellForRow).
*/
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as! MyCell
        if cell.textLabel!.numberOfLines != 2 { // never previously configured
            cell.textLabel!.font = UIFont(name:"Helvetica-Bold", size:16)
            cell.textLabel!.lineBreakMode = .ByWordWrapping
            cell.textLabel!.numberOfLines = 2
            // next line fails, I regard this as a bug
            // cell.separatorInset = UIEdgeInsetsMake(0,0,0,0)
        }
        
        cell.textLabel!.text = "The author of this book, who would rather be out dirt biking"
        
        // shrink apparent size of image
        let im = UIImage(named:"moi.png")!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36,36), true, 0.0)
        im.drawInRect(CGRectMake(0,0,36,36))
        let im2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        cell.imageView!.image = im2
        cell.imageView!.contentMode = .Center
        
        return cell
    }
    
    /*
    You can see we are using the nib, because the table view has a green background.
*/
    

}