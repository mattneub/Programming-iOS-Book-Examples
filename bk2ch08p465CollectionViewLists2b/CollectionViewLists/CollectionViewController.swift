
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class CollectionViewController: UICollectionViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private let cellId = "Cell"
    private let headerId = "Header"
    override func viewDidLoad() {
        super.viewDidLoad()
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: self.cellId)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerId)
    }
    
    let data = ["Manny", "Moe", "Jack"]
    var favorite: Int?
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10 // so we can experiment with behavior
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! UICollectionViewListCell
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = data[indexPath.item]
        cell.accessories = self.favorite == indexPath.item ? [.checkmark()] : []
        cell.contentConfiguration = contentConfig
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.favorite = indexPath.item
        delay(0.2) {
            collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath)
        var lab : UIView! = v.viewWithTag(1)
        if lab == nil {
            lab = UILabel()
            lab.tag = 1
            lab.translatesAutoresizingMaskIntoConstraints = false
            v.addSubview(lab)
            lab.topAnchor.constraint(equalTo: v.topAnchor, constant: 5).isActive = true
            lab.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -5).isActive = true
            lab.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 15).isActive = true
            v.backgroundColor = .lightGray
            v.layer.zPosition = 1
        }
        (lab as! UILabel).text = "Pep \(indexPath.section)"
        return v
    }
}
