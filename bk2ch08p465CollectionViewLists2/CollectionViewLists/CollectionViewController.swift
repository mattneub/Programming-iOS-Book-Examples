

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
    override func viewDidLoad() {
        super.viewDidLoad()
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: self.cellId)

    }

    let data = ["Pep", "Manny", "Moe", "Jack"]
    var favorite: Int?

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.item != 0 // not "header" cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.favorite = indexPath.item
        delay(0.2) {
            collectionView.reloadData()
        }
    }


}
