

import UIKit

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
extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}



class ViewController: UICollectionViewController {

    private static func prepareLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { index, env in
            switch index {
            case 0...1:
                // custom groups
                let sz = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let group = NSCollectionLayoutGroup.custom(layoutSize: sz) { env in
                    var items = [NSCollectionLayoutGroupCustomItem]()
                    let w = CGFloat(40)
                    var frame = CGRect(0, 0, w, env.container.contentSize.height)
                    while true {
                        items.append(NSCollectionLayoutGroupCustomItem(frame: frame))
                        frame.origin.x += w + 10
                        frame.size.height -= 6; frame.origin.y += 3
                        if frame.size.height < 20 {
                            return items
                        }
                        if frame.maxX > env.container.contentSize.width {
                            return items
                        }
                    }
                }
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 20
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
                return section
            case 2...3:
                // groups as items
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.5))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let vgroupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.48),
                    heightDimension: .absolute(60))
                let vgroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: vgroupSize, subitems: [item])
                let hgroupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60))
                let hgroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: hgroupSize, subitems: [vgroup])
                hgroup.interItemSpacing = .flexible(1)
                let section = NSCollectionLayoutSection(group: hgroup)
                section.interGroupSpacing = 20
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
                return section
            case 4...5:
                // orthogonal scrolling
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 20
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            default: fatalError("oops")
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        layout.configuration = config
        return layout
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.collectionViewLayout = Self.prepareLayout()
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if cell.viewWithTag(1) == nil {
            let lab = UILabel()
            lab.text = "TEST"
            lab.sizeToFit()
            lab.tag = 1
            cell.contentView.addSubview(lab)
            cell.contentView.layer.borderWidth = 2
            
            lab.textAlignment = .center
        }
        let lab = cell.contentView.viewWithTag(1) as! UILabel
        lab.text = String(indexPath.item)
        lab.frame = cell.bounds
        return cell
    }

}

