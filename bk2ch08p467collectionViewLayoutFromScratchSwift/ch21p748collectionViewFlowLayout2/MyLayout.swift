
import UIKit

class MyLayout : UICollectionViewLayout {
    
    var sz = CGSizeZero
    var atts = [NSIndexPath:UICollectionViewLayoutAttributes]()
    
    // absolute rock-bottom layout from scratch, shows minimal responsibilities
    
    override func prepareLayout() {
        print("prepare")
        let sections = self.collectionView!.numberOfSections()
        
        /*
        // how many items are there in total?
        let total = Array(0 ..< sections).map {
            self.collectionView!.numberOfItemsInSection($0)
            }.reduce(0, combine: +)
        */
        
        // work out cell size based on bounds size
        let sz = self.collectionView!.bounds.size
        let width = sz.width
        let shortside = floor(width/50.0)
        let cellside = width/shortside
        
        // generate attributes for all cells
        var x = 0
        var y = 0
        var atts = [UICollectionViewLayoutAttributes]()
        for i in 0 ..< sections {
            let jj = self.collectionView!.numberOfItemsInSection(i)
            for j in 0 ..< jj {
                let att = UICollectionViewLayoutAttributes(
                    forCellWithIndexPath:
                    NSIndexPath(forItem:j, inSection:i))
                att.frame = CGRectMake(CGFloat(x)*cellside,CGFloat(y)*cellside,cellside,cellside)
                atts += [att]
                x++
                if CGFloat(x) >= shortside {
                    x = 0
                    y++
                }
            }
        }
        for att in atts {
            self.atts[att.indexPath] = att
        }
        let fluff = (x == 0) ? 0 : 1
        self.sz = CGSizeMake(width, CGFloat(y+fluff) * cellside)
    }
    
    override func collectionViewContentSize() -> CGSize {
        //        println("size")
        return self.sz
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let ok = newBounds.size.width != self.sz.width
        print("should \(ok)")
        return ok
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        print("atts")
        return self.atts[indexPath]
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //        println("rect")
        return Array(self.atts.values)
    }
}