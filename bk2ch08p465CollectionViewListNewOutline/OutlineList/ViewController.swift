

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UICollectionViewController {
    
    var datasource : UICollectionViewDiffableDataSource<String,String>!
    
    override func loadView() {
        self.view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        let app = UINavigationBarAppearance()
        app.backgroundColor = .black
        app.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.standardAppearance = app
        
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView = cv
        cv.delegate = self
        cv.dataSource = self
        self.view.addSubview(cv)
        cv.frame = self.view.bounds
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let cellreg = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, ip, s in
            var config = cell.defaultContentConfiguration()
            config.text = s
            cell.contentConfiguration = config
//            cell.accessories = [.outlineDisclosure()]
//            return;
            let snap = self.datasource.snapshot(for: "Groups")
            let snap2 = snap.snapshot(of: s, includingParent: false)
            let hasChildren = snap2.items.count > 0
            cell.accessories = hasChildren ? [.outlineDisclosure()] : []
        }
        
//        let headreg = UICollectionView.SupplementaryRegistration<UICollectionViewCell>(elementKind: UICollectionView.elementKindSectionHeader) { cell, kind, ip in
//            let section = ip.section
//            var config = UIListContentConfiguration.cell()
//            config.text = self.datasource.snapshot().sectionIdentifiers[section]
//            config.textProperties.color = .white
//            cell.contentConfiguration = config
//            var back = UIBackgroundConfiguration.listPlainHeaderFooter()
//            back.backgroundColor = .black
//            cell.backgroundConfiguration = back
//        }
        
        self.datasource = UICollectionViewDiffableDataSource<String,String>(collectionView:cv) { cv, ip, s in
            cv.dequeueConfiguredReusableCell(using: cellreg, for: ip, item: s)
        }
//        self.datasource.supplementaryViewProvider = { cv, kind, ip in
//            cv.dequeueConfiguredReusableSupplementary(using: headreg, for: ip)
//        }
        
        var snap = NSDiffableDataSourceSectionSnapshot<String>()
        snap.append(["Pep", "Marx"], to: nil) // root
        snap.append(["Manny", "Moe", "Jack"], to: "Pep")
        snap.append(["Groucho", "Harpo", "Chico", "Other"], to: "Marx")
        snap.append(["Zeppo", "Gummo"], to: "Other")
        self.datasource.apply(snap, to: "Groups", animatingDifferences: false)
        


    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("bingo")
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        let snap = self.datasource.snapshot(for: "Groups")
//        let s = self.datasource.itemIdentifier(for: indexPath)!
//        let snap2 = snap.snapshot(of: s, includingParent: false)
//        let hasChildren = snap2.items.count > 0
//        return !hasChildren
        var snap = self.datasource.snapshot(for: "Groups")
        let s = self.datasource.itemIdentifier(for: indexPath)!
        let snap2 = snap.snapshot(of: s, includingParent: false)
        let hasChildren = snap2.items.count > 0
        if hasChildren {
//            delay(0.1) {
                if snap.isExpanded(s) {
                    snap.collapse([s])
                } else {
                    snap.expand([s])
                }
                self.datasource.apply(snap, to: "Groups")
//            }
        }
        return !hasChildren
    }

}

