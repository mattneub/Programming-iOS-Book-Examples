
import UIKit

// example of a decoration view

class MyTitleView : UICollectionReusableView {
    weak var lab : UILabel!
    override init(frame: CGRect) {
        super.init(frame:frame)
        let lab = UILabel(frame:self.bounds)
        self.addSubview(lab)
        lab.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        lab.font = UIFont(name: "GillSans-Bold", size: 40)
        self.lab = lab
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func apply(_ atts: UICollectionViewLayoutAttributes) {
        if let atts = atts as? MyTitleViewLayoutAttributes {
            self.lab.text = atts.title
        }
    }
}

class MyTitleViewLayoutAttributes : UICollectionViewLayoutAttributes {
    var title = ""
}

class MyFlowLayout : UICollectionViewFlowLayout {
    
    private let titleKind = "title"
    private let titleHeight : CGFloat = 50
    private var titleRect : CGRect {
        return CGRect(10,0,200,self.titleHeight)
    }
    var title = "" // this is public API, client should set

    override init() {
        super.init()
        self.register(MyTitleView.self, forDecorationViewOfKind:self.titleKind)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        var sz = super.collectionViewContentSize
        sz.height += self.titleHeight
        return sz
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arr = super.layoutAttributesForElements(in: rect)!
        arr = arr.map {
            atts -> UICollectionViewLayoutAttributes in
            var atts = atts
            switch atts.representedElementCategory {
            case .cell:
                let ip = atts.indexPath
                atts = self.layoutAttributesForItem(at:ip)!
            case .supplementaryView:
                let ip = atts.indexPath
                let kind = atts.representedElementKind!
                atts = self.layoutAttributesForSupplementaryView(ofKind: kind, at: ip)!
            default:break
            }
            return atts
        }
        // include attributes for decoration view
        if let decatts = self.layoutAttributesForDecorationView(
            ofKind:self.titleKind, at: IndexPath(item: 0, section: 0)) {
                if rect.intersects(decatts.frame) {
                    arr.append(decatts)
                }
        }
        return arr
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var atts = super.layoutAttributesForItem(at:indexPath)!
        atts = atts.copy() as! UICollectionViewLayoutAttributes
        atts.frame.origin.y += self.titleHeight
        if indexPath.item == 0 {
            return atts // degenerate case 1
        }
        if atts.frame.origin.x - 1 <= self.sectionInset.left {
            return atts // degenerate case 2
        }
        let ipPv = IndexPath(item:indexPath.row-1, section:indexPath.section)
        let fPv = self.layoutAttributesForItem(at:ipPv)!.frame
        let rightPv = fPv.origin.x + fPv.size.width + self.minimumInteritemSpacing
        atts.frame.origin.x = rightPv
        return atts
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var atts = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)!
        atts = atts.copy() as! UICollectionViewLayoutAttributes
        atts.frame.origin.y += self.titleHeight
        return atts
    }
    
    // this is where the action is
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == self.titleKind {
            // how to create layout attributes
            let atts = MyTitleViewLayoutAttributes(forDecorationViewOfKind:self.titleKind, with:indexPath)
            // use attributes subclass to communicate instance variable to decoration view
            atts.title = self.title
            atts.frame = self.titleRect
            return atts
        }
        return nil
    }
    
}
