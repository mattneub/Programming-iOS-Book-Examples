
import UIKit

extension Array {
    mutating func remove(at ixs:[Int]) -> () {
        for i in ixs.sorted(isOrderedBefore:>) {
            self.remove(at:i)
        }
    }
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class ViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var sectionNames = [String]()
    var sectionData = [[String]]()
    lazy var modelCell : Cell = { // load lazily from nib
        () -> Cell in
        let arr = UINib(nibName:"Cell", bundle:nil).instantiate(withOwner:nil, options:nil)
        return arr[0] as! Cell
        }()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        let s = try! String(contentsOfFile: NSBundle.main().pathForResource("states", ofType: "txt")!, encoding: NSUTF8StringEncoding)
        let states = s.components(separatedBy:"\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = String(aState.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append( c.uppercased() )
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append( [String]() )
            }
            sectionData[sectionData.count-1].append( aState )
        }
        
        let b = UIBarButtonItem(title:"Switch", style:.plain, target:self, action:#selector(doSwitch(_:)))
        self.navigationItem.leftBarButtonItem = b
        
        let b2 = UIBarButtonItem(title:"Delete", style:.plain, target:self, action:#selector(doDelete(_:)))
        self.navigationItem.rightBarButtonItem = b2
        
        self.collectionView!.backgroundColor = UIColor.white()
        self.collectionView!.allowsMultipleSelection = true
        
        // register cell, comes from a nib even though we are using a storyboard
        self.collectionView!.register(UINib(nibName:"Cell", bundle:nil), forCellWithReuseIdentifier:"Cell")
        // register headers
        self.collectionView!.register(UICollectionReusableView.self,
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader,
            withReuseIdentifier:"Header")
        
        self.navigationItem.title = "States"
        
        // if you don't do something about header size...
        // ...you won't see any headers
        let flow = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        self.setUpFlowLayout(flow)
    }
    
    func setUpFlowLayout(_ flow:UICollectionViewFlowLayout) {
        flow.headerReferenceSize = CGSize(50,50) // larger - we will place label within this
        flow.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10) // looks nicer
        
        // flow.sectionHeadersPinToVisibleBounds = true // try cool new iOS 9 feature
        
        // uncomment to crash
        // flow.estimatedItemSize = CGSize(100,30)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionData[section].count
    }
    
    // headers
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var v : UICollectionReusableView! = nil
        if kind == UICollectionElementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier:"Header", for: indexPath) 
            if v.subviews.count == 0 {
                let lab = UILabel() // we will size it later
                v.addSubview(lab)
                lab.textAlignment = .center
                // look nicer
                lab.font = UIFont(name:"Georgia-Bold", size:22)
                lab.backgroundColor = UIColor.lightGray()
                lab.layer.cornerRadius = 8
                lab.layer.borderWidth = 2
                lab.layer.masksToBounds = true // has to be added for iOS 8 label
                lab.layer.borderColor = UIColor.black().cgColor
                lab.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    NSLayoutConstraint.constraints(withVisualFormat:"H:|-10-[lab(35)]",
                        metrics:nil, views:["lab":lab]),
                    NSLayoutConstraint.constraints(withVisualFormat:"V:[lab(30)]-5-|",
                    metrics:nil, views:["lab":lab])
                ].flatten().map{$0})
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = self.sectionNames[indexPath.section]
        }
        return v
    }
    
    // cells
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"Cell", for: indexPath) as! Cell
        if cell.lab.text == "Label" { // new cell
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 2
            
            cell.backgroundColor = UIColor.gray()
            
            // checkmark in top left corner when selected
            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
            let con = UIGraphicsGetCurrentContext()!
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.darkGray()
            shadow.shadowOffset = CGSize(2,2)
            shadow.shadowBlurRadius = 4
            let check2 =
            NSAttributedString(string:"\u{2714}", attributes:[
                NSFontAttributeName: UIFont(name:"ZapfDingbatsITC", size:24)!,
                NSForegroundColorAttributeName: UIColor.green(),
                NSStrokeColorAttributeName: UIColor.red(),
                NSStrokeWidthAttributeName: -4,
                NSShadowAttributeName: shadow
                ])
            con.scale(x:1.1, y:1)
            check2.draw(at:CGPoint(2,0))
            let im = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            let iv = UIImageView(image:nil, highlightedImage:im)
            iv.isUserInteractionEnabled = false
            cell.addSubview(iv)
        }
        cell.lab.text = self.sectionData[indexPath.section][indexPath.row]
        var stateName = cell.lab.text!
        // flag in background! very cute
        stateName = stateName.lowercased()
        stateName = stateName.replacingOccurrences(of:" ", with:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        let iv = UIImageView(image:im)
        iv.contentMode = .scaleAspectFit
        cell.backgroundView = iv
        
        return cell
    }
    
    // what's the minimum size each cell can be? its constraints will figure it out for us!
    
    // NB According to Apple, in iOS 8 I should be able to eliminate this code;
    // simply turning on estimatedItemSize should do it for me (sizing according to constraints)
    // but I have not been able to get that feature to work
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: NSIndexPath) -> CGSize {
        // note; this approach didn't work on iOS 8...
        // ...until I introduced the "container" view
        // systemLayoutSize works on the container view but not on the cell itself in iOS 8
        // (perhaps because the nib lacks a contentView)
        // Oooh, fixed (6.1)!
        self.modelCell.lab.text = self.sectionData[indexPath.section][indexPath.row]
        //the "container" workaround is no longer needed
        //var sz = self.modelCell.container.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        var sz = self.modelCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        sz.width = ceil(sz.width); sz.height = ceil(sz.height)
        return sz
    }
    
    // selection: nothing to do!
    // we get automatic highlighting of whatever can be highlighted (i.e. our UILabel)
    // we get automatic overlay of the selectedBackgroundView
    
    // =======================
    
    // can just change layouts on the fly! with built-in animation!!!
    func doSwitch(_ sender:AnyObject!) { // button
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
    
    func doDelete(_ sender:AnyObject) { // button, delete selected cells
        let arr = self.collectionView!.indexPathsForSelectedItems()!
        if arr.count == 0 {
            return
        }
        // sort
        let arr2 = ((arr as NSArray).sortedArray(using:#selector(NSIndexPath.compare(_:))) as! [NSIndexPath])
        // delete data
        var empties = [Int]() // keep track of what sections get emptied
        for ip in arr2.reversed() {
            self.sectionData[ip.section].remove(at:ip.item)
            if self.sectionData[ip.section].count == 0 {
                empties += [ip.section]
            }
        }
        // will need an NSIndexSet version of that empties list
        let emptyset = NSMutableIndexSet()
        for i in empties {
            emptyset.add(i)
        }
        // request the deletion from the view; notice the slick automatic animation
        self.collectionView!.performBatchUpdates({
            self.collectionView!.deleteItems(at:arr2)
            if empties.count > 0 { // delete empty sections
                self.sectionNames.remove(at:empties) // see utility function at top of file
                self.sectionData.remove(at:empties)
                self.collectionView!.deleteSections(emptyset)
            }
            })
    }
    
    // menu =================
    
    // exactly as for table views
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: NSIndexPath) -> Bool {
        let mi = UIMenuItem(title:"Capital", action:#selector(Cell.capital))
        UIMenuController.shared().menuItems = [mi]
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return (action == #selector(copy(_:))) || (action == #selector(Cell.capital))
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: NSIndexPath, withSender sender: AnyObject?) {
        // in real life, would do something here
        let state = self.sectionData[indexPath.section][indexPath.row]
        if action == #selector(copy(_:)) {
            print ("copying \(state)")
        }
        else if action == #selector(Cell.capital) {
            print ("fetching the capital of \(state)")
        }
    }
}
