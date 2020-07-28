

import UIKit

class CollectionViewController: UICollectionViewController {
    init() {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        // this works too
        // config.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        super.init(collectionViewLayout: layout)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private let cellId = "Cell"
    
    var dataSource: UICollectionViewDiffableDataSource<String, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // new notation in iOS 14: no need to register a cell! (or supplementary item)
        // instead, a Registration struct has a closure...
        // and in the diffable data source, you just return the Configured cell or supplementary
        typealias CellReg = UICollectionView.CellRegistration
        let reg = CellReg<UICollectionViewListCell, String> { cell, ip, s in
            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.text = s
            if ip.item == 0 {
                let opts = UICellAccessory.OutlineDisclosureOptions(style: .header)
                let f : () -> () = { print("ha!") }
                cell.accessories = [.outlineDisclosure(options: opts, actionHandler: nil)]
            } else {
                cell.accessories = []
            }
            cell.contentConfiguration = contentConfig
        }
        let ds = UICollectionViewDiffableDataSource<String, String>(collectionView:self.collectionView) { cv, ip, s in
            cv.dequeueConfiguredReusableCell(using: reg, for: ip, item: s)
        }
        self.dataSource = ds
        // and now... (drum roll) outlines!
        var snap = NSDiffableDataSourceSectionSnapshot<String>()
        snap.append(["Pep"]) // to:nil
        snap.append(["Manny", "Moe", "Jack"], to: "Pep")
        // section is created for us
        self.dataSource.apply(snap, to: "Dummy", animatingDifferences: false)
    }
}
