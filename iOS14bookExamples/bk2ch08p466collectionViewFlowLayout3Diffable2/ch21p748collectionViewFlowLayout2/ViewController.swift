
import UIKit

class ViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var datasource : UICollectionViewDiffableDataSource<String,String>!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
        
    override func viewDidLoad() {
        typealias CellReg = UICollectionView.CellRegistration
        typealias SuppReg = UICollectionView.SupplementaryRegistration
        // registration _objects_, new in iOS 14, cute eh
        let cellReg = CellReg<Cell, String>(
            cellNib: UINib(nibName:"Cell", bundle:nil)) { [weak self]
            cell, ip, s in self?.configureCell(cell, ip, s)
        }
        let headReg = SuppReg<UICollectionReusableView> (
            elementKind: UICollectionView.elementKindSectionHeader) { [weak self]
            v, kind, ip in self?.configureHeader(v, kind, ip)
        }
        // in the data source,dequeue a Configured cell or supplementary item
        self.datasource = UICollectionViewDiffableDataSource<String,String>(collectionView:self.collectionView) { cv,ip,s in
            cv.dequeueConfiguredReusableCell(using: cellReg, for: ip, item: s)
        }
        self.datasource.supplementaryViewProvider = { cv,kind,ip in
            cv.dequeueConfiguredReusableSupplementary(using: headReg, for: ip)
        }
        
        let s = try! String(
            contentsOfFile: Bundle.main.path(
                forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        let d = Dictionary(grouping: states) {String($0.prefix(1))}
        let sections = Array(d).sorted {$0.key < $1.key} // *
        // let's use the new section snapshots!
        for section in sections {
            var snap = NSDiffableDataSourceSectionSnapshot<String>()
            snap.append(section.1)
            datasource.apply(snap, to: section.0, animatingDifferences: false)
        }


        let b = UIBarButtonItem(title:"Switch", style:.plain, target:self, action:#selector(doSwitch(_:)))
        self.navigationItem.leftBarButtonItem = b
        
        let b2 = UIBarButtonItem(title:"Delete", style:.plain, target:self, action:#selector(doDelete(_:)))
        self.navigationItem.rightBarButtonItem = b2
        
        self.collectionView.backgroundColor = .white
        self.collectionView.allowsMultipleSelection = true
        
        self.navigationItem.title = "States"
        
        // if you don't do something about header size...
        // ...you won't see any headers
        let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        self.setUpFlowLayout(flow)
    }
    
    func setUpFlowLayout(_ flow:UICollectionViewFlowLayout) {
        flow.headerReferenceSize = CGSize(50,50) // larger - we will place label within this
        flow.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10) // looks nicer
        flow.itemSize = CGSize(100,30)
    }
    
    // headers
    
    // configuration no longer needs to _return_ anything
    func configureHeader(_ v:UICollectionReusableView, _ kind:String, _ indexPath:IndexPath) {
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
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-10-[lab(35)]",
                                               metrics:nil, views:["lab":lab]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:[lab(30)]-5-|",
                                               metrics:nil, views:["lab":lab])
                ].flatMap {$0})
        }
        let lab = v.subviews[0] as! UILabel
        let snap = self.datasource.snapshot()
        lab.text = snap.sectionIdentifiers[indexPath.section]
    }
    
    // cells
    
    // configuration no longer needs to _return_ anything
    func configureCell(_ cell:Cell, _ indexPath:IndexPath, _ s:String) {
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
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // can just change layouts on the fly! with built-in animation!!!
    @objc func doSwitch(_ sender: Any) { // button
        // new iOS 7 property collectionView.collectionViewLayout points to *original* layout, which is preserved
        let oldLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        var newLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        if newLayout == oldLayout {
            newLayout = MyFlowLayout()
        }
        self.setUpFlowLayout(newLayout)
        self.collectionView.setCollectionViewLayout(newLayout, animated:true)
    }
    
    // =======================
    
    // deletion, really quite similar to a table view
    
    @IBAction func doDelete(_ sender: Any) { // button, delete selected cells
        guard var arr = self.collectionView.indexPathsForSelectedItems,
            arr.count > 0 else {return}
        // sort
        /*
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
        self.collectionView.performBatchUpdates {
            self.collectionView.deleteItems(at:arr)
            if empties.count > 0 { // delete empty sections
                self.sections.remove(at:empties) // see utility function at top of file
                self.collectionView.deleteSections(IndexSet(empties)) // Set turns directly into IndexSet!
            }
        }
 */
    }
    
    

}
