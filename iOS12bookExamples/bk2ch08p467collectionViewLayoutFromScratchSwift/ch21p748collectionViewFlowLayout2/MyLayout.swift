
import UIKit

class MyLayout : UICollectionViewLayout {
    
    var sz = CGSize.zero
    var atts = [IndexPath:UICollectionViewLayoutAttributes]()
    
    // absolute rock-bottom layout from scratch, shows minimal responsibilities
    
    override func prepare() {
        
        //print("prepare1")
        let sections = self.collectionView!.numberOfSections
        
        /*
        // how many items are there in total?
        let total = Array(0 ..< sections).map {
            self.collectionView!.numberOfItemsInSection($0)
            }.reduce(0, combine: +)
        */
        
        // work out cell size based on bounds size
        let sz = self.collectionView!.bounds.size
        let width = sz.width
        let shortside = (width/50.0).rounded(.down)
        let side = width/shortside
        
        // generate attributes for all cells
        var (x,y) = (0,0)
        var atts = [UICollectionViewLayoutAttributes]()
        for i in 0 ..< sections {
            let jj = self.collectionView!.numberOfItems(inSection:i)
            for j in 0 ..< jj {
                let att = UICollectionViewLayoutAttributes(
                    forCellWith: IndexPath(item:j, section:i))
                att.frame = CGRect(CGFloat(x)*side,CGFloat(y)*side,side,side)
                atts += [att]
                x += 1
                if CGFloat(x) >= shortside {
                    x = 0; y += 1
                }
            }
        }
        for att in atts {
            self.atts[att.indexPath] = att
        }
        let fluff = (x == 0) ? 0 : 1
        self.sz = CGSize(width, CGFloat(y+fluff) * side)
    }
    
    override var collectionViewContentSize : CGSize {
        //print("size1")
        return self.sz
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let ok = newBounds.size != self.sz
        // print("should1 \(ok)")
        return ok
    }
    
    // sigh... okay, but now we are being called even when the _other_ layout is supposed to be in charge
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        //print("atts1")
        //print("layout is \(self.collectionView!.collectionViewLayout)")

        return self.atts[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //print("rect1")
        return Array(self.atts.values)
    }
    

}
