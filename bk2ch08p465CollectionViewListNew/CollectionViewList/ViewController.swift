

import UIKit

class MyHeightLimitedCell: UICollectionViewCell {
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let atts = super.preferredLayoutAttributesFitting(layoutAttributes)
        atts.size.height = 40
        return atts
    }
}

class ViewController: UICollectionViewController {
    
    var datasource : UICollectionViewDiffableDataSource<String,String>!
    
    override func loadView() {
        self.view = UIView()
    }

//    override var prefersStatusBarHidden: Bool { true }
    
    // I regard the need for this as a bug
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated:animated)
        self.collectionView.isEditing = editing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "States"
        let app = UINavigationBarAppearance()
        app.backgroundColor = .black
        app.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.standardAppearance = app
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        // I regard the need for this as a bug
        self.navigationItem.rightBarButtonItem?.primaryAction = UIAction(title:"Edit") { _ in
            self.setEditing(!self.isEditing, animated: true)
        }

        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .supplementary
        config.trailingSwipeActionsConfigurationProvider = { ip in
            let delete = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
                self.delete(at: ip)
                completion(true)
            }
            let swipe = UISwipeActionsConfiguration(actions: [delete])
            return swipe
        }
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
            var stateName = s
            stateName = stateName.lowercased()
            stateName = stateName.replacingOccurrences(of: " ", with:"")
            stateName = "flag_\(stateName).gif"
            let im = UIImage(named: stateName)
            // config.image = im // not used in article screen shots
            cell.contentConfiguration = config
            // default gray selection indicator, not needed if we're using list cells
//            var back = UIBackgroundConfiguration.listPlainCell()
//            back.customView = nil
//            cell.backgroundConfiguration = back
            
            let reorder = UICellAccessory.reorder()
            let delete = UICellAccessory.delete()
            cell.accessories = [delete, reorder]
            
        }
        
        let headreg = UICollectionView.SupplementaryRegistration<UICollectionViewCell>(elementKind: UICollectionView.elementKindSectionHeader) { cell, kind, ip in
            let section = ip.section
            var config = UIListContentConfiguration.cell()
            config.text = self.datasource.snapshot().sectionIdentifiers[section] // *
            config.textProperties.font = UIFont(name:"Georgia-Bold", size:22)!
            config.textProperties.color = .green
            config.image = UIImage(named:"us_flag_small.gif")
            config.imageProperties.maximumSize = CGSize(width:0, height:20)
            cell.contentConfiguration = config
            var back = UIBackgroundConfiguration.listPlainHeaderFooter()
            back.backgroundColor = .black
            cell.backgroundConfiguration = back
        }
        
        self.datasource = UICollectionViewDiffableDataSource<String,String>(collectionView:cv) { cv, ip, s in
            cv.dequeueConfiguredReusableCell(using: cellreg, for: ip, item: s)
        }
        self.datasource.supplementaryViewProvider = { cv, kind, ip in
            cv.dequeueConfiguredReusableSupplementary(using: headreg, for: ip)
        }
        
        let s = try! String(
            contentsOfFile: Bundle.main.path(
                forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n").filter {!$0.isEmpty} // ??? why is this suddenly needed I'd like to know
        let d = Dictionary(grouping: states) {String($0.prefix(1))}
        let sections = Array(d).sorted {$0.key < $1.key}
        print(sections)
        var snap = NSDiffableDataSourceSnapshot<String,String>()
        for section in sections {
            snap.appendSections([section.0])
            snap.appendItems(section.1)
        }
        self.datasource.apply(snap, animatingDifferences: false)
        
        // make cells reorderable
        self.datasource.reorderingHandlers.canReorderItem = { item in return true }


    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("bingo")
    }
    
    // limit dragging to within section
    override func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        print("here")
        if originalIndexPath.section == proposedIndexPath.section {
            return proposedIndexPath
        }
        return originalIndexPath
    }
    
    func delete(at ip: IndexPath) {
        var snap = self.datasource.snapshot()
        if let ident = self.datasource.itemIdentifier(for: ip) {
            snap.deleteItems([ident])
        }
        self.datasource.apply(snap)
    }

}

