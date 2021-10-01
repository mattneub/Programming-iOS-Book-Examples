

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
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: self.cellId)

    }

    let data = ["Manny", "Moe", "Jack"]
    var favorite: Int?

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // note use of list cell; not required but behaves more like t.v.
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


}
