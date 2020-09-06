
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
        self.collectionView.register(UICollectionViewListCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerId)
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
    
    // Apple says: for the header of a collection view list, use a list cell!
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as! UICollectionViewListCell
        var contentConfig = v.defaultContentConfiguration()
        contentConfig.text = "Pep \(indexPath.section)"
        v.contentConfiguration = contentConfig
        // this was a bug workaround, but they fixed the bug
        // v.layer.zPosition = 1
        return v
    }
}
