
import UIKit

extension Array {
    mutating func removeAtIndexes (ixs:[Int]) -> () {
        for i in ixs.sorted(>) {
            self.removeAtIndex(i)
        }
    }
}

class ViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var sectionNames = [String]()
    var sectionData = [[String]]()
    lazy var modelCell : Cell = { // load lazily from nib
        () -> Cell in
        let arr = UINib(nibName:"Cell", bundle:nil).instantiateWithOwner(nil, options:nil)
        return arr[0] as! Cell
        }()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        let s = String(contentsOfFile: NSBundle.mainBundle().pathForResource("states", ofType: "txt")!, encoding: NSUTF8StringEncoding, error: nil)!
        let states = s.componentsSeparatedByString("\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = (aState as NSString).substringWithRange(NSMakeRange(0,1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append( c.uppercaseString )
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append( [String]() )
            }
            sectionData[sectionData.count-1].append( aState )
        }
        
        let b = UIBarButtonItem(title:"Switch", style:.Plain, target:self, action:"doSwitch:")
        self.navigationItem.leftBarButtonItem = b
        
        let b2 = UIBarButtonItem(title:"Delete", style:.Plain, target:self, action:"doDelete:")
        self.navigationItem.rightBarButtonItem = b2
        
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        self.collectionView!.allowsMultipleSelection = true
        
        // register cell, comes from a nib even though we are using a storyboard
        self.collectionView!.registerNib(UINib(nibName:"Cell", bundle:nil), forCellWithReuseIdentifier:"Cell")
        // register headers
        self.collectionView!.registerClass(UICollectionReusableView.self,
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader,
            withReuseIdentifier:"Header")
        
        self.navigationItem.title = "States"
        
        // if you don't do something about header size...
        // ...you won't see any headers
        let flow = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        self.setUpFlowLayout(flow)
    }
    
    func setUpFlowLayout(flow:UICollectionViewFlowLayout) {
        flow.headerReferenceSize = CGSizeMake(50,50) // larger - we will place label within this
        flow.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10) // looks nicer
        // uncomment to crash
        // flow.estimatedItemSize = CGSizeMake(100,30)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.sectionNames.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionData[section].count
    }
    
    // headers
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var v : UICollectionReusableView! = nil
        if kind == UICollectionElementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier:"Header", forIndexPath:indexPath) as! UICollectionReusableView
            if v.subviews.count == 0 {
                let lab = UILabel() // we will size it later
                v.addSubview(lab)
                lab.textAlignment = .Center
                // look nicer
                lab.font = UIFont(name:"Georgia-Bold", size:22)
                lab.backgroundColor = UIColor.lightGrayColor()
                lab.layer.cornerRadius = 8
                lab.layer.borderWidth = 2
                lab.layer.masksToBounds = true // has to be added for iOS 8 label
                lab.layer.borderColor = UIColor.blackColor().CGColor
                lab.setTranslatesAutoresizingMaskIntoConstraints(false)
                v.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[lab(35)]",
                        options:nil, metrics:nil, views:["lab":lab]))
                v.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat("V:[lab(30)]-5-|",
                        options:nil, metrics:nil, views:["lab":lab]))
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = self.sectionNames[indexPath.section]
        }
        return v
    }
    
    // cells
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! Cell
        if cell.lab.text == "Label" { // new cell
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 2
            
            cell.backgroundColor = UIColor.grayColor()
            
            // checkmark in top left corner when selected
            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
            let con = UIGraphicsGetCurrentContext()
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.darkGrayColor()
            shadow.shadowOffset = CGSizeMake(2,2)
            shadow.shadowBlurRadius = 4
            let check2 =
            NSAttributedString(string:"\u{2714}", attributes:[
                NSFontAttributeName: UIFont(name:"ZapfDingbatsITC", size:24)!,
                NSForegroundColorAttributeName: UIColor.greenColor(),
                NSStrokeColorAttributeName: UIColor.redColor(),
                NSStrokeWidthAttributeName: -4,
                NSShadowAttributeName: shadow
                ])
            CGContextScaleCTM(con, 1.1, 1)
            check2.drawAtPoint(CGPointMake(2,0))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let iv = UIImageView(image:nil, highlightedImage:im)
            iv.userInteractionEnabled = false
            cell.addSubview(iv)
        }
        cell.lab.text = self.sectionData[indexPath.section][indexPath.row]
        var stateName = cell.lab.text!
        // flag in background! very cute
        stateName = stateName.lowercaseString
        stateName = stateName.stringByReplacingOccurrencesOfString(" ", withString:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        let iv = UIImageView(image:im)
        iv.contentMode = .ScaleAspectFit
        cell.backgroundView = iv
        
        return cell
    }
    
    // what's the minimum size each cell can be? its constraints will figure it out for us!
    
    // NB According to Apple, in iOS 8 I should be able to eliminate this code;
    // simply turning on estimatedItemSize should do it for me (sizing according to constraints)
    // but I have not been able to get that feature to work
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // note; this approach didn't work on iOS 8...
        // ...until I introduced the "container" view
        // systemLayoutSize works on the container view but not on the cell itself in iOS 8
        // (perhaps because the nib lacks a contentView)
        // Oooh, fixed (6.1)!
        self.modelCell.lab.text = self.sectionData[indexPath.section][indexPath.row]
        //the "container" workaround is no longer needed
        //var sz = self.modelCell.container.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        var sz = self.modelCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        sz.width = ceil(sz.width); sz.height = ceil(sz.height)
        return sz
    }
    
    // selection: nothing to do!
    // we get automatic highlighting of whatever can be highlighted (i.e. our UILabel)
    // we get automatic overlay of the selectedBackgroundView
    
    // =======================
    
    // can just change layouts on the fly! with built-in animation!!!
    func doSwitch(sender:AnyObject!) { // button
        // new iOS 7 property collectionView.collectionViewLayout points to *original* layout, which is preserved
        let oldLayout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        var newLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        if newLayout == oldLayout {
            newLayout = MyFlowLayout()
        }
        self.setUpFlowLayout(newLayout)
        self.collectionView!.setCollectionViewLayout(newLayout, animated:true)
    }
    
    // =======================
    
    // deletion, really quite similar to a table view
    
    func doDelete(sender:AnyObject) { // button, delete selected cells
        let arr = self.collectionView!.indexPathsForSelectedItems() as! [NSIndexPath]
        if arr.count == 0 {
            return
        }
        // sort
        let arr2 = (arr as NSArray).sortedArrayUsingSelector(Selector("compare:")).reverse() as! [NSIndexPath]
        // delete data
        var empties = [Int]() // keep track of what sections get emptied
        for ip in arr2 {
            self.sectionData[ip.section].removeAtIndex(ip.item)
            if self.sectionData[ip.section].count == 0 {
                empties += [ip.section]
            }
        }
        // will need an NSIndexSet version of that empties list
        let emptyset = NSMutableIndexSet()
        for i in empties {
            emptyset.addIndex(i)
        }
        // request the deletion from the view; notice the slick automatic animation
        self.collectionView!.performBatchUpdates({
            self.collectionView!.deleteItemsAtIndexPaths(arr2)
            if empties.count > 0 { // delete empty sections
                self.sectionNames.removeAtIndexes(empties) // see utility function at top of file
                self.sectionData.removeAtIndexes(empties)
                self.collectionView!.deleteSections(emptyset)
            }
            }, completion: nil)
    }
    
    // menu =================
    
    // exactly as for table views
    
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let mi = UIMenuItem(title:"Capital", action:"capital:")
        UIMenuController.sharedMenuController().menuItems = [mi]
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject) -> Bool {
        return (action == "copy:") || (action == "capital:")
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject) {
        // in real life, would do something here
        let state = self.sectionData[indexPath.section][indexPath.row]
        if action == "copy:" {
            println ("copying \(state)")
        }
        else if action == "capital:" {
            println ("fetching the capital of \(state)")
        }
    }
}
