

import UIKit

class PepListCompactViewController: UICollectionViewController {
    
    var datasource: UICollectionViewDiffableDataSource<String, String>!
    
    convenience init() {
        self.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pep"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        self.collectionView.collectionViewLayout = layout
        
        typealias CellReg = UICollectionView.CellRegistration
        let reg = CellReg<UICollectionViewListCell, String> { cell, ip, s in
            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.text = s
            cell.contentConfiguration = contentConfig
            cell.accessories = [.disclosureIndicator()]
        }
        let ds = UICollectionViewDiffableDataSource<String, String>(collectionView:self.collectionView) {
            cv, ip, s in
            cv.dequeueConfiguredReusableCell(using: reg, for: ip, item: s)
        }
        self.datasource = ds
        
        var snap = NSDiffableDataSourceSectionSnapshot<String>()
        snap.append(["Manny", "Moe", "Jack"])
        self.datasource.apply(snap, to: "Dummy", animatingDifferences: false)
    }
    
    fileprivate func respondToSelection(_ indexPath: IndexPath) {
        let snap = self.datasource.snapshot()
        let boy = snap.itemIdentifiers[indexPath.row]
        let pep = PepCompact(pepBoy: boy)
        // in the compact case, just push
        self.navigationController?.pushViewController(pep, animated: true)
        (self.splitViewController?.parent as? ViewController)?.chosenBoy = boy
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.respondToSelection(indexPath)
    }
    
}
