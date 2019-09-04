
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

class Deco : UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NSDiffableDataSourceSnapshot {
    mutating func deleteWithSections(_ items : [ItemIdentifierType]) {
        self.deleteItems(items)
        let empties = self.sectionIdentifiers.filter {
            self.numberOfItems(inSection: $0) == 0
        }
        self.deleteSections(empties)
    }
}

class MyDiffable : UICollectionViewDiffableDataSource<String,String> {
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return collectionView.collectionViewLayout is MyFlowLayout
    }
    
    override func collectionView(_ cv: UICollectionView, moveItemAt source: IndexPath, to dest: IndexPath) {
        print("move")
        let srcid = self.itemIdentifier(for: source)!
        let destid = self.itemIdentifier(for: dest)!
        var snap = self.snapshot()
        if dest.item > source.item {
            snap.moveItem(srcid, afterItem: destid)
        } else {
            snap.moveItem(srcid, beforeItem: destid)
        }
        self.apply(snap, animatingDifferences:false)
    }
}

class ViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    static let header = "Header"
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                             heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        group.interItemSpacing = .fixed(15)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 15, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .estimated(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: Self.header, alignment: .top)
        header.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(10), trailing: nil, bottom: .fixed(10))
        section.boundarySupplementaryItems = [header]
        
        let deco = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        deco.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.decorationItems = [deco]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

        
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    let cellID = "Cell"
	let headerID = "Header"
    
    // UICollectionViewDiffableDataSource is pickier than table view diffable
    // must register stuff before applying data
    // and if there are supplementary views, must have a supplementary view provider!
    lazy var datasource = MyDiffable(collectionView: self.collectionView) { cv, ip, s in
        return self.makeCell(cv, ip, s)
    }
    
    override func viewDidLoad() {
        // register _before_ there is data
        self.collectionView.register(UINib(nibName:"Cell", bundle:nil), forCellWithReuseIdentifier: self.cellID)
        self.collectionView.register(UICollectionReusableView.self,
                                      forSupplementaryViewOfKind:Self.header,
            withReuseIdentifier: self.headerID)
        self.collectionView.register(UICollectionReusableView.self,
                                      forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: self.headerID)
        
        // create supp view provider _before_ there is data
        self.datasource.supplementaryViewProvider = { cv, kind, ip in
            return self.makeHeader(cv, kind, ip)
        }
        
        // ok, _now_ make the data!
        let s = try! String(
            contentsOfFile: Bundle.main.path(
                forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        let d = Dictionary(grouping: states) {String($0.prefix(1))}
        let sections = Array(d).sorted{$0.key < $1.key} // *
        
        var snap = NSDiffableDataSourceSnapshot<String,String>() // whoa, now struct?
        for section in sections {
            snap.appendSections([section.0])
            snap.appendItems(section.1)
        }
        self.datasource.apply(snap, animatingDifferences: false)

        let b = UIBarButtonItem(title:"Switch", style:.plain, target:self, action:#selector(doSwitch(_:)))
        self.navigationItem.leftBarButtonItem = b
        
        let b2 = UIBarButtonItem(title:"Delete", style:.plain, target:self, action:#selector(doDelete(_:)))
        self.navigationItem.rightBarButtonItem = b2
        
        self.collectionView.backgroundColor = .white
        self.collectionView.allowsMultipleSelection = true
        
        self.navigationItem.title = "States"
        
        let layout = self.createLayout()
        layout.register(Deco.self, forDecorationViewOfKind: "background")
        self.collectionView.collectionViewLayout = layout
    }
    
    
    func setUpFlowLayout(_ flow:UICollectionViewFlowLayout) {
        flow.headerReferenceSize = CGSize(50,50) // larger - we will place label within this
        flow.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10) // looks nicer
        flow.itemSize = CGSize(100,30)
        
//         flow.sectionHeadersPinToVisibleBounds = true // try cool new iOS 9 feature
        
//         uncomment to crash
//         cripes, now we don't crash, but the layout is wrong! can these guys never get this implemented???
//         also tried doing this by overriding sizeThatFits in the cell, but with the same wrong layout
//         also tried doing it by overriding preferredAttributes in the cell, same wrong layout
//         just uncommenting this line causes solo cells to be centered! insane
//         flow.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    
    // headers
    
    func makeHeader(_ cv: UICollectionView, _ kind: String, _ ip: IndexPath) -> UICollectionReusableView {
        
        var v : UICollectionReusableView! = nil
        v = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerID, for: ip)
        if v.subviews.count == 0 {
            let lab = UILabel() // we will size it later
            v.addSubview(lab)
            lab.textAlignment = .center
            // look nicer
            lab.font = UIFont(name:"Georgia-Bold", size:22)
            lab.backgroundColor = .lightGray
            lab.layer.cornerRadius = 8
            lab.layer.borderWidth = 2
            lab.layer.masksToBounds = true // has to be added for iOS 8 label
            lab.layer.borderColor = UIColor.black.cgColor
            lab.translatesAutoresizingMaskIntoConstraints = false
            var cons = [
                lab.widthAnchor.constraint(equalToConstant: 30),
                lab.heightAnchor.constraint(equalToConstant: 30),
                lab.topAnchor.constraint(equalTo: v.topAnchor, constant:10),
                lab.leadingAnchor.constraint(equalTo: v.leadingAnchor),
                lab.bottomAnchor.constraint(equalTo: v.bottomAnchor),
            ]
            if kind == UICollectionView.elementKindSectionHeader {
                cons = [
                    lab.widthAnchor.constraint(equalToConstant: 30),
                    lab.heightAnchor.constraint(equalToConstant: 30),
                    lab.topAnchor.constraint(equalTo: v.topAnchor, constant:10),
                    lab.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant:10),
                    lab.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant:-10),
                ]
            }
            NSLayoutConstraint.activate(cons)
        }
        let lab = v.subviews[0] as! UILabel
        // lab.text = self.sections[ip.section].sectionName
        // becomes:
        lab.text = self.datasource.snapshot().sectionIdentifiers[ip.section]
        return v
    }
    
    // cells
    
    func makeCell(_ cv: UICollectionView, _ ip: IndexPath, _ s: String) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: ip) as! Cell
        if cell.lab.text == "Label" { // new cell
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 2
            
            cell.backgroundColor = .gray
            
            // checkmark in top left corner when selected
            let r = UIGraphicsImageRenderer(size:cell.bounds.size)
            let im = r.image {
                ctx in let con = ctx.cgContext
                let shadow = NSShadow()
                shadow.shadowColor = UIColor.darkGray
                shadow.shadowOffset = CGSize(2,2)
                shadow.shadowBlurRadius = 4
                let check2 =
                    NSAttributedString(string:"\u{2714}", attributes:[
                        .font: UIFont(name:"ZapfDingbatsITC", size:24)!,
                        .foregroundColor: UIColor.green,
                        .strokeColor: UIColor.red,
                        .strokeWidth: -4,
                        .shadow: shadow
                        ])
                con.scaleBy(x:1.1, y:1)
                check2.draw(at:CGPoint(2,0))
            }

            let iv = UIImageView(image:nil, highlightedImage:im)
            iv.isUserInteractionEnabled = false
            cell.addSubview(iv)
        }
        cell.lab.text = s
        var stateName = cell.lab.text!
        // flag in background! very cute
        stateName = stateName.lowercased()
        stateName = stateName.replacingOccurrences(of:" ", with:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        let iv = UIImageView(image:im)
        iv.contentMode = .scaleAspectFit
        cell.backgroundView = iv
        
        return cell
    }
    
    // what's the minimum size each cell can be? its constraints will figure it out for us!
    
    // NB According to Apple, in iOS 8 I should be able to eliminate this code;
    // simply turning on estimatedItemSize should do it for me (sizing according to constraints)
    // but I have not been able to get that feature to work
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let memosize = self.sections[indexPath.section].itemData[indexPath.row].size
        if memosize != .zero {
            return memosize
        }
        
        self.modelCell.lab.text = self.sections[indexPath.section].itemData[indexPath.row].name
        // nope
        // return UICollectionViewFlowLayout.automaticSize
        // NB this is what I was getting wrong all these years
        // you have to size the _contentView_
        // (no more container view trickery)
        var sz = self.modelCell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        sz.width = ceil(sz.width); sz.height = ceil(sz.height)
        self.sections[indexPath.section].itemData[indexPath.row].size = sz // memoize
        return sz
    }
 */
 
    
    // selection: nothing to do!
    // we get automatic highlighting of whatever can be highlighted (i.e. our UILabel)
    // we get automatic overlay of the selectedBackgroundView
    
    // =======================
    
    // can just change layouts on the fly! with built-in animation!!!
    @objc func doSwitch(_ sender: Any) { // button
        // new iOS 7 property collectionView.collectionViewLayout points to *original* layout, which is preserved
        let newLayout : UICollectionViewLayout = {
            let oldLayout = self.collectionView.collectionViewLayout
            if oldLayout is MyFlowLayout {
                return self.createLayout()
            }
            let layout = MyFlowLayout()
            self.setUpFlowLayout(layout)
            return layout
        }()
        self.collectionView.setCollectionViewLayout(newLayout, animated:true)
    }
    
    // =======================
    
    // deletion, really quite similar to a table view
    
    @IBAction func doDelete(_ sender: Any) { // button, delete selected cells
        guard let sel = self.collectionView.indexPathsForSelectedItems,
            sel.count > 0 else {return}
        let itemids = sel.map {
            self.datasource.itemIdentifier(for: $0)
        }.compactMap {$0}
        var snap = self.datasource.snapshot()
        snap.deleteWithSections(itemids)
        self.datasource.apply(snap)

        /*
        // sort
        arr.sort()
        // delete data
        var empties : Set<Int> = [] // keep track of what sections get emptied
        for ip in arr.reversed() {
            self.sections[ip.section].itemData.remove(at:ip.item)
            if self.sections[ip.section].itemData.count == 0 {
                empties.insert(ip.section)
            }
        }
        // request the deletion from the view; notice the slick automatic animation
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at:arr)
            if empties.count > 0 { // delete empty sections
                self.sections.remove(at:empties) // see utility function at top of file
                self.collectionView.deleteSections(IndexSet(empties)) // Set turns directly into IndexSet!
            }
        })
 */
    }
    
    // works but doesn't play very well with selection because we highlight first
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return nil // for dragging
        let config = UIContextMenuConfiguration(identifier:nil, previewProvider: nil) { _ in
            let action = UIAction(title: "Copy") { _ in
                let d = self.datasource
                if let state = d.itemIdentifier(for: indexPath) {
                    UIPasteboard.general.string = state
                    print("copied", state)
                }
            }
            let menu = UIMenu(title: "", children: [action])
            return menu
        }
        return config
    }
    
    // now THIS is cool
    // note there's no editing mode involved, we just select
    override func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print("did highlight")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        print("did unhighlight")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("did deselect")
    }
    
    // dragging ===============
    
    // on by default; data source merely has to permit
    
    // -------- interactive moving, data source methods
            
    // modify using delegate methods
    // here, prevent moving outside your own section
    
    
    // wait - orig and prop are always the same as each other! what sense does that make????
    // no, not _always_! have to watch for that case

    override func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt orig: IndexPath, toProposedIndexPath prop: IndexPath) -> IndexPath {
        print("from", orig, "target", prop)
        if orig.section != prop.section {
            return orig
        }
        return prop
//        if orig.item == prop.item {
//            return prop
//        }
        // they are different, we're crossing a boundary - shift size values!
//        var sizes = self.sections[orig.section].itemData.map{$0.size}
//        let size = sizes.remove(at: orig.item)
//        sizes.insert(size, at:prop.item)
//        for (ix,size) in sizes.enumerated() {
//            self.sections[orig.section].itemData[ix].size = size
//        }
//        return prop
    }
}



class MyFlowLayout : UICollectionViewFlowLayout {
    // how to left-justify every "line" of the layout
    // looks much nicer, in my humble opinion
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let arr = super.layoutAttributesForElements(in: rect)!
        return arr.map { atts in
            var atts = atts
            if atts.representedElementCategory == .cell {
                let ip = atts.indexPath
                atts = self.layoutAttributesForItem(at:ip)!
            }
            return atts
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var atts = super.layoutAttributesForItem(at:indexPath)!
        if indexPath.item == 0 {
            return atts // degenerate case 1
        }
        if atts.frame.origin.x - 1 <= self.sectionInset.left {
            return atts // degenerate case 2
        }
        let ipPv = IndexPath(item:indexPath.row-1, section:indexPath.section)
        let fPv = self.layoutAttributesForItem(at:ipPv)!.frame
        let rightPv = fPv.origin.x + fPv.size.width + self.minimumInteritemSpacing
        atts = atts.copy() as! UICollectionViewLayoutAttributes
        atts.frame.origin.x = rightPv
        return atts
    }

}

