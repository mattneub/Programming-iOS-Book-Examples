

import UIKit

class ViewController : UICollectionViewController {
    
    var sectionNames = [String]()
    var sectionData = [[String]]()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
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
        
        self.collectionView!.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        // if you don't do something about header size...
        // ...you won't see any headers
        let flow = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        flow.headerReferenceSize = CGSizeMake(30,30)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.sectionNames.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionData[section].count
    }
    
    // minimal formatting; this is just to prove we can show the data at all
    
    // headers 
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var v : UICollectionReusableView! = nil
        if kind == UICollectionElementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier:"Header", forIndexPath:indexPath) 
            if v.subviews.count == 0 {
                v.addSubview(UILabel(frame:CGRectMake(0,0,30,30)))
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = (self.sectionNames)[indexPath.section]
            lab.textAlignment = .Center
        }
        return v
    }
    
    // cells
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath:indexPath) 
        if cell.contentView.subviews.count == 0 {
            cell.contentView.addSubview(UILabel(frame:CGRectMake(0,0,30,30)))
        }
        let lab = cell.contentView.subviews[0] as! UILabel
        lab.text = (self.sectionData)[indexPath.section][indexPath.item] // "item" synonym for "row"
        lab.sizeToFit()
        return cell

    }
}

// but the above is not sufficient to see the entire name of a state
// the state names are stepping on each other; let's fix that
// adjust the size of each cell, as a UICollectionViewDelegateFlowLayout

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // note horrible duplication of code here
        let lab = UILabel(frame:CGRectMake(0,0,30,30))
        lab.text = (self.sectionData)[indexPath.section][indexPath.item]
        lab.sizeToFit()
        return lab.bounds.size
    }
}

// that duplication is exactly what iOS 8 is supposed to fix with _automatic_ variable cell size
// but I can't get that to work (see next example for my workaround using constraints)

