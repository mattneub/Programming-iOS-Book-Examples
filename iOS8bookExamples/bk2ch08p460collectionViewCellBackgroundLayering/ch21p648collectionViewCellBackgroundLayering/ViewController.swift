
import UIKit

class ViewController : UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(150,50)
        
        let v = UIView()
        v.backgroundColor = UIColor.yellowColor()
        // next line makes the whole background yellow, covering the background color
        // self.collectionView.backgroundView = v
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    // window background is white
    // collection view background (from storyboard) is green
    
    /*
    the window background never appears
    the collection view background appears when you "bounce" the scroll beyond its limits
    ...but is also visible behind all cells
    (I have not found a way to make the two different)
    the red cell background color is behind the cell
    the linen cell background view is on top of that
    the (translucent, here) selected background view is on top of that
    the content view and its contents are on top of that
    */
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell",
        forIndexPath:indexPath) as! UICollectionViewCell
        if cell.backgroundView == nil { // brand new cell
            cell.backgroundColor = UIColor.redColor()
            
            let v = UIImageView(frame:cell.bounds)
            v.contentMode = .ScaleToFill
            v.image = UIImage(named:"linen.png")
            cell.backgroundView = v
            
            let v2 = UIView(frame:cell.bounds)
            v2.backgroundColor = UIColor(white:0.2, alpha:0.1)
            cell.selectedBackgroundView = v2
            
            let lab = UILabel()
            lab.setTranslatesAutoresizingMaskIntoConstraints(false)
            lab.tag = 1
            cell.contentView.addSubview(lab)
            cell.contentView.addConstraint(
            NSLayoutConstraint(item:lab, attribute:.CenterX,
            relatedBy:.Equal,
            toItem:cell.contentView, attribute:.CenterX, multiplier:1, constant:0))
            cell.contentView.addConstraint(
            NSLayoutConstraint(item:lab, attribute:.CenterY,
            relatedBy:.Equal,
                toItem:cell.contentView, attribute:.CenterY, multiplier:1, constant:0))
            lab.textColor = UIColor.blackColor()
            lab.highlightedTextColor = UIColor.whiteColor()
            lab.backgroundColor = UIColor.clearColor()
        }
        let lab = cell.viewWithTag(1) as! UILabel
        lab.text = "Howdy there \(indexPath.item)"
        return cell
    }
    
}
