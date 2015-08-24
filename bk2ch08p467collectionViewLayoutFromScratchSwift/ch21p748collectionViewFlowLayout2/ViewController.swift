

import UIKit

/*
I've provided two independent versions of this example, one Swift, one Objective-C,
because the Swift version is prohibitively slow (especially on a device)
*/


class ViewController : UICollectionViewController {
    
    var sectionNames = [String]()
    var sectionData = [[String]]()
    lazy var modelCell : Cell = { // load lazily from nib
        () -> Cell in
        let arr = UINib(nibName:"Cell", bundle:nil).instantiateWithOwner(nil, options:nil)
        return arr[0] as! Cell
        }()

    override func viewDidLoad() {
        let s = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("states", ofType: "txt")!, encoding: NSUTF8StringEncoding)
        let states = s.componentsSeparatedByString("\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = String(aState.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append( c.uppercaseString )
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append( [String]() )
            }
            sectionData[sectionData.count-1].append( aState )
        }
        self.navigationItem.title = "States"
        let bb = UIBarButtonItem(title:"Push", style:.Plain, target:self, action:"doPush:")
        self.navigationItem.rightBarButtonItem = bb
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        self.collectionView!.allowsMultipleSelection = true
        
        // register cell, comes from a nib even though we are using a storyboard
        self.collectionView!.registerNib(UINib(nibName:"Cell", bundle:nil), forCellWithReuseIdentifier:"Cell")
        // register headers (for the other view controller!)
        self.collectionView!.registerClass(UICollectionReusableView.self,
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader,
            withReuseIdentifier:"Header")

        // no supplementary views or anything
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
            v = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier:"Header", forIndexPath:indexPath)
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
                lab.translatesAutoresizingMaskIntoConstraints = false
                v.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[lab(35)]",
                        options:[], metrics:nil, views:["lab":lab]))
                v.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat("V:[lab(30)]-5-|",
                        options:[], metrics:nil, views:["lab":lab]))
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
            let con = UIGraphicsGetCurrentContext()!
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        self.modelCell.lab.text = self.sectionData[indexPath.section][indexPath.row]
        var sz = self.modelCell.container.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        sz.width = ceil(sz.width); sz.height = ceil(sz.height)
        return sz
    }

    func doPush(sender:AnyObject?) {
        self.performSegueWithIdentifier("push", sender: self)
    }

}
