
import UIKit

class MyFlowLayout : UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            guard let cv = self.collectionView else { return nil }
            let r = CGRect(origin:cv.contentOffset, size:cv.bounds.size)
            let arr = super.layoutAttributesForElements(in: rect)!
            return arr.map { atts in
                let atts = atts.copy() as! UICollectionViewLayoutAttributes
                if atts.representedElementCategory == .cell {
                    if atts.frame.intersects(r) {
                        let d = abs(r.midX - atts.center.x)
                        let act = CGFloat(70)
                        let nd = d/act
                        if d < act {
                            let scale = 1 + 0.5*(1-(abs(nd)))
                            let t = CATransform3DMakeScale(scale,scale,1)
                            atts.transform3D = t
                        }
                    }
                }
                return atts
            }
    }
}

class MyComp : UICollectionViewCompositionalLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            guard let cv = self.collectionView else { return nil }
            let r = CGRect(origin:cv.contentOffset, size:cv.bounds.size)
            let arr = super.layoutAttributesForElements(in: rect)!
            return arr.map { atts in
                let atts = atts.copy() as! UICollectionViewLayoutAttributes
                if atts.representedElementCategory == .cell {
                    if atts.frame.intersects(r) {
                        let d = abs(r.midX - atts.center.x)
                        let act = CGFloat(70)
                        let nd = d/act
                        if d < act {
                            let scale = 1 + 0.5*(1-(abs(nd)))
                            let t = CATransform3DMakeScale(scale,scale,1)
                            atts.transform3D = t
                        }
                    }
                }
                return atts
            }
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    static func prepareLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .flexible(0), trailing: nil, bottom: .flexible(0))
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(75), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 65
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 75, bottom: 0, trailing: 75)
        section.visibleItemsInvalidationHandler = { items, offset, env in
            let r = CGRect(origin:offset, size:env.container.contentSize)
            let cells = items.filter {$0.representedElementCategory == .cell}
            for item in cells {
                let d = abs(r.midX - item.center.x)
                let act = CGFloat(70)
                let nd = d/act
                if d < act {
                    let scale = 1 + 0.5*(1-(abs(nd)))
                    let t = CATransform3DMakeScale(scale,scale,1)
                    item.transform3D = t
                }
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(section: section, configuration:config)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.collectionViewLayout = Self.prepareLayout()
        if let lay = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            lay.itemSize = CGSize(width: 75, height: 75)
            lay.minimumLineSpacing = 65
            lay.sectionInset = UIEdgeInsets(top: 0, left: 85, bottom: 0, right: 85)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
}

