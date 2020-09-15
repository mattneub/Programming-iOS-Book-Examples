
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

// failed experiment: I can animate the NSCollectionLayoutVisibleItem objects directly...
// but then we don't see anything actually happening
// but then why are they UIDynamicItems, if I can't display them animating?

class ViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.collectionViewLayout = self.prepareLayout()
        let bbi = UIBarButtonItem(title: "Flush", style: .plain, target: self, action: #selector(doFlush))
        self.navigationItem.rightBarButtonItem = bbi
    }

    var anim : UIDynamicAnimator?
    
    @objc func doFlush() {
        self.anim = UIDynamicAnimator()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
        
    private func prepareLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        section.visibleItemsInvalidationHandler = { items, offset, env in
            print("here")
            guard let anim = self.anim else { return }
            guard !anim.isRunning else { return }
            print("go")
//            var atts = [UICollectionViewLayoutAttributes]()
//            for ip in cv.indexPathsForVisibleItems {
//                if let att = cv.layoutAttributesForItem(at: ip) {
//                    let beh = UIDynamicItemBehavior(items:[att])
//                    beh.resistance = CGFloat.random(in: 0.2...6)
//                    beh.addAngularVelocity(CGFloat.random(in: -2...2), for: att)
//                    anim.addBehavior(beh)
//                    atts.append(att)
//                }
//            }
            let grav = UIGravityBehavior(items: items)
            grav.action = {
                // have to prompt for another frame
                self.collectionView.collectionViewLayout.invalidateLayout()
                let items = anim.items(in: self.collectionView.bounds)
                if items.count == 0 {
                    print("done")
                    anim.removeAllBehaviors()
                    self.anim = nil
                }
            }
            anim.addBehavior(grav)
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

