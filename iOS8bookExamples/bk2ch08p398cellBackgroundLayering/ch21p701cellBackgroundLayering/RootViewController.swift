
import UIKit

class RootViewController : UITableViewController {
    let cellIdentifier = "Cell"
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    // window background is white
    // table view background is green
    
    /*
    the window background never appears
    the table view background appears when you "bounce" the scroll beyond its limits
    the red cell background color is behind the cell
    the linen cell background view is on top of that
    the (translucent, here) selected background view is on top of that
    the content view and its contents are on top of that
    */
    
    /*
    Simple "dequeue" (without "forIndexPath") might return a nil cell, and certainly will at the
    outset as the initial stack of reusable cells is needed. This means that everything in the code
    has to accommodate this possibility: the cell must be a var because you might need to create
    and assign it, the cell must be typed as an Optional, and all references to the cell must be
    unwrapped. This is annoying - and completely unnecessary. I'm only showing it here
    for illustrative purposes. For the rest of the book, I'll use dequeue...:forIndexPath: which
    has none of those issues, and the cell will never be an Optional (or nil) ever again.
*/
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style:.Default, reuseIdentifier:cellIdentifier)
            
            cell.textLabel!.textColor = UIColor.whiteColor()
            
            let v = UIImageView() // no need to set frame
            v.contentMode = .ScaleToFill
            v.image = UIImage(named:"linen.png")
            cell.backgroundView = v
            
            let v2 = UIView() // no need to set frame
            v2.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.2)
            cell.selectedBackgroundView = v2;
            // next line no longer necessary in iOS 7!
            // cell.textLabel.backgroundColor = UIColor.clearColor()
            
            // next line didn't work until iOS 7!
            cell.backgroundColor = UIColor.redColor()
            
//            let b = UIButton.buttonWithType(.System) as! UIButton
//            b.setTitle("Tap Me", forState:.Normal)
//            b.sizeToFit()
//            cell.accessoryView = b
            
            // cell.textLabel!.font = UIFont(name:"Helvetica-Bold", size:12.0)

            
        }
        cell.textLabel!.text = "Hello there! \(indexPath.row)"
        
        return cell
    }
    
    /*
    
    override func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        println(cell.backgroundColor) // no need to set it here in iOS 7...
        // ...the color set in cellForRow has held
        println(cell.textLabel.backgroundColor) // no need to set label background color to clear...
        // ...it is not being rejiggered
    }

*/

}