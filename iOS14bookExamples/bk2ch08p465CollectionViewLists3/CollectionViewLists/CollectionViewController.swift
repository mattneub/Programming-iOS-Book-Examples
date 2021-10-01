

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class CollectionViewController: UICollectionViewController {
    init() {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        super.init(collectionViewLayout: layout)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private let cellId = "Cell"
    
    var datasource: UICollectionViewDiffableDataSource<String, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // start over
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        // this works too
        // config.headerMode = .firstItemInSection
        config.trailingSwipeActionsConfigurationProvider = { indexPath in
            if indexPath.item == 0 { return nil }
            let del = UIContextualAction(style: .destructive, title: "Delete") {
                [weak self] action, view, completion in
                self?.delete(at: indexPath)
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [del])
        }
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        self.collectionView.collectionViewLayout = layout
        
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem // works!
        // new notation in iOS 14: no need to register a cell! (or supplementary item)
        // instead, a Registration struct has a closure...
        // and in the diffable data source, you just return the Configured cell or supplementary
        typealias CellReg = UICollectionView.CellRegistration
        let reg = CellReg<UICollectionViewListCell, String> { cell, ip, s in
            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.text = s
            let snap = self.datasource.snapshot(for: "Dummy")
            let snap2 = snap.snapshot(of: s)
            if snap2.items.count > 0 {
//            if ip.item == 0 {
//                let opts = UICellAccessory.OutlineDisclosureOptions(style: .header)
//                let f : () -> () = { print("ha!") }
//                cell.accessories = [.outlineDisclosure(options: opts, actionHandler: nil)]
                cell.accessories = [.outlineDisclosure()]
            } else {
                cell.accessories = [.delete()]
            }
            cell.contentConfiguration = contentConfig
        }
        let ds = UICollectionViewDiffableDataSource<String, String>(collectionView:self.collectionView) { cv, ip, s in
            cv.dequeueConfiguredReusableCell(using: reg, for: ip, item: s)
        }
        self.datasource = ds
        // and now... (drum roll) outlines!
        var snap = NSDiffableDataSourceSectionSnapshot<String>()
        snap.append(["Pep"]) // to:nil
        snap.append(["Manny", "Moe", "Jack"], to: "Pep")
        // section is created for us
        self.datasource.apply(snap, to: "Dummy", animatingDifferences: false)
        
        delay(2) {
            let snap = self.datasource.snapshot(for: "Dummy")
            print(snap.visualDescription())
            let level = snap.level(of: "Pep")
            print(level)
            let snap2 = snap.snapshot(of: "Pep")
            let children = snap2.rootItems
            print(children)
        }
    }
    
    func delete(at ip: IndexPath) {
        var snap = self.datasource.snapshot()
        if let ident = self.datasource.itemIdentifier(for: ip) {
            snap.deleteItems([ident])
        }
        self.datasource.apply(snap)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        var snap = self.datasource.snapshot(for: "Dummy")
        let s = self.datasource.itemIdentifier(for: indexPath)!
        let snap2 = snap.snapshot(of: s)
        let hasChildren = snap2.items.count > 0
        if hasChildren {
            if snap.isExpanded(s) {
                snap.collapse([s])
            } else {
                snap.expand([s])
            }
            self.datasource.apply(snap, to: "Dummy")
        }
        return !hasChildren
    }

}
