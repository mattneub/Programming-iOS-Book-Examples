
import UIKit

class MyLayout : UICollectionViewLayout {
    
    var sz = CGSize.zero
    var atts = [IndexPath:UICollectionViewLayoutAttributes]()
    
    // absolute rock-bottom layout from scratch, shows minimal responsibilities
    
    override func prepare() {
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
            let jj = self.collectionView!.numberOfItems(inSection:i)
            for j in 0 ..< jj {
                let att = UICollectionViewLayoutAttributes(
                    forCellWith:
                    IndexPath(item:j, section:i))
                att.frame = CGRect(CGFloat(x)*cellside,CGFloat(y)*cellside,cellside,cellside)
                atts += [att]
                x += 1
                if CGFloat(x) >= shortside {
                    x = 0
                    y += 1
                }
            }
        }
        for att in atts {
            self.atts[att.indexPath] = att
        }
        let fluff = (x == 0) ? 0 : 1
        self.sz = CGSize(width, CGFloat(y+fluff) * cellside)
    }
    
    override func collectionViewContentSize() -> CGSize {
        //        println("size")
        return self.sz
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let ok = newBounds.size.width != self.sz.width
        print("should \(ok)")
        return ok
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("atts")
        return self.atts[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //        println("rect")
        return Array(self.atts.values)
    }
}
