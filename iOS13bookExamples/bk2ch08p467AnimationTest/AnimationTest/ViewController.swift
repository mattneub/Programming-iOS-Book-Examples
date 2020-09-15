
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.collectionViewLayout = self.prepareLayout()
        let bbi = UIBarButtonItem(title: "Flush", style: .plain, target: self, action: #selector(doFlush))
        self.navigationItem.rightBarButtonItem = bbi
    }

    var anim : UIDynamicAnimator?
    
    @objc func doFlush() {
        let cv = self.collectionView!
        
        let layout = cv.collectionViewLayout
        let anim = UIDynamicAnimator(collectionViewLayout: layout)
        var atts = [UICollectionViewLayoutAttributes]()
        for ip in cv.indexPathsForVisibleItems {
            if let att = cv.layoutAttributesForItem(at: ip) {
                let beh = UIDynamicItemBehavior(items:[att])
                beh.resistance = CGFloat.random(in: 0.2...6)
                beh.addAngularVelocity(CGFloat.random(in: -2...2), for: att)
                anim.addBehavior(beh)
                atts.append(att)
            }
        }
        let grav = UIGravityBehavior(items: atts)
        grav.action = {
            let items = anim.items(in: self.collectionView.bounds)
            if items.count == 0 {
                print("done")
                anim.removeAllBehaviors()
                self.anim = nil
            }
        }
        anim.addBehavior(grav)
        self.anim = anim
    }
        
    private func prepareLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        section.visibleItemsInvalidationHandler = { items, offset, env in
            if let anim = self.anim {
                print("go")
                for item in items {
                    if let atts = anim.layoutAttributesForCell(at:item.indexPath) {
                        item.center = atts.center
                        item.transform3D = atts.transform3D
                    }
                }
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(section: section, configuration:config)

        return layout
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = .red
        cell.layer.borderWidth = 2
        return cell
    }
    
}

