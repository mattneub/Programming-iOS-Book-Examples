
import UIKit

extension Array {
    mutating func remove(at ixs:Set<Int>) -> () {
        for i in Array<Int>(ixs).sorted(by:>) {
            self.remove(at:i)
        }
    }
}

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



class ViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    struct Item {
        var name : String
        var size : CGSize
    }
    struct Section {
        var sectionName : String
        var itemData : [Item]
    }
    var sections : [Section]!

    lazy var modelCell : Cell = { // load lazily from nib
        () -> Cell in
        let arr = UINib(nibName:"Cell", bundle:nil).instantiate(withOwner:nil)
        return arr[0] as! Cell
        }()
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    let cellID = "Cell"
	let headerID = "Header"
    
    override func viewDidLoad() {
        let s = try! String(
            contentsOfFile: Bundle.main.path(
                forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        let d = Dictionary(grouping: states) {String($0.prefix(1))}
        let d2 = d.mapValues{$0.map {Item(name:$0, size:.zero)}}
        self.sections = Array(d2).sorted{$0.key < $1.key}.map {
            Section(sectionName: $0.key, itemData: $0.value)
        }

        let b = UIBarButtonItem(title:"Switch", style:.plain, target:self, action:#selector(doSwitch(_:)))
        self.navigationItem.leftBarButtonItem = b
        
        let b2 = UIBarButtonItem(title:"Delete", style:.plain, target:self, action:#selector(doDelete(_:)))
        self.navigationItem.rightBarButtonItem = b2
        
        self.collectionView!.backgroundColor = .white
        self.collectionView!.allowsMultipleSelection = true
        
        // register cell, comes from a nib even though we are using a storyboard
        self.collectionView!.register(UINib(nibName:"Cell", bundle:nil), forCellWithReuseIdentifier: self.cellID)
        // register headers
        self.collectionView!.register(UICollectionReusableView.self,
            forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: self.headerID)
        
        self.navigationItem.title = "States"
        
        // if you don't do something about header size...
        // ...you won't see any headers
        let flow = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        self.setUpFlowLayout(flow)
    }
    
    func setUpFlowLayout(_ flow:UICollectionViewFlowLayout) {
        flow.headerReferenceSize = CGSize(50,50) // larger - we will place label within this
        flow.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10) // looks nicer
        
        // flow.sectionHeadersPinToVisibleBounds = true // try cool new iOS 9 feature
        
        // uncomment to crash
        // cripes, now we don't crash, but the layout is wrong! can these guys never get this implemented???
        // also tried doing this by overriding sizeThatFits in the cell, but with the same wrong layout
        // also tried doing it by overriding preferredAttributes in the cell, same wrong layout
        // just uncommenting this line causes solo cells to be centered! insane
        // flow.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].itemData.count
    }
    
    // headers
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var v : UICollectionReusableView! = nil
        if kind == UICollectionView.elementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerID, for: indexPath) 
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
                ].flatMap{$0})
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = self.sections[indexPath.section].sectionName
        }
        return v
    }
    
    // cells
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! Cell
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
        cell.lab.text = self.sections[indexPath.section].itemData[indexPath.row].name
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
    
//    /*
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
// */
 
    
    // selection: nothing to do!
    // we get automatic highlighting of whatever can be highlighted (i.e. our UILabel)
    // we get automatic overlay of the selectedBackgroundView
    
    // =======================
    
    // can just change layouts on the fly! with built-in animation!!!
    @objc func doSwitch(_ sender: Any!) { // button
        // new iOS 7 property collectionView.collectionViewLayout points to *original* layout, which is preserved
        let oldLayout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        var newLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        if newLayout == oldLayout {
            newLayout = MyFlowLayout()
        }
        self.setUpFlowLayout(newLayout)
        self.collectionView!.setCollectionViewLayout(newLayout, animated:true)
    }
    
    // =======================
    
    // deletion, really quite similar to a table view
    
    @IBAction func doDelete(_ sender: Any) { // button, delete selected cells
        guard var arr = self.collectionView!.indexPathsForSelectedItems,
            arr.count > 0 else {return}
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
        self.collectionView!.performBatchUpdates({
            self.collectionView!.deleteItems(at:arr)
            if empties.count > 0 { // delete empty sections
                self.sections.remove(at:empties) // see utility function at top of file
                self.collectionView!.deleteSections(IndexSet(empties)) // Set turns directly into IndexSet!
            }
        })
    }
    
    // menus moved to next example
    // you can't have both menus and dragging
    // (because they both use the long press gesture, I presume)

    
    // dragging ===============
    
    // on by default; data source merely has to permit
    
    // -------- interactive moving, data source methods
    
    var origSections : [Section]!
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        print("move is starting")
        self.origSections = self.sections
        return true
    }
    
    override func collectionView(_ cv: UICollectionView, moveItemAt source: IndexPath, to dest: IndexPath) {
        print("move")
        if source.section == dest.section {
            // restore sizes
            self.sections = self.origSections
            // rearrange model
            func move<T>(_ arr:inout Array<T>, from:Int, to:Int) {
                let el = arr.remove(at: from)
                arr.insert(el, at: to)
            }
            move(&self.sections[source.section].itemData, from:source.item, to:dest.item)
            // update interface - wait, no need any longer!!!!
            // cv.reloadSections(IndexSet(integer:source.section))
        }
    }
    
    // modify using delegate methods
    // here, prevent moving outside your own section
    
    
    // wait - orig and prop are always the same as each other! what sense does that make????
    // no, not _always_! have to watch for that case
    override func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt orig: IndexPath, toProposedIndexPath prop: IndexPath) -> IndexPath {
        print("from", orig, "target", prop)
        if orig.section != prop.section {
            return orig
        }
        if orig.item == prop.item {
            return prop
        }
        // they are different, we're crossing a boundary - shift size values!
        var sizes = self.sections[orig.section].itemData.map{$0.size}
        let size = sizes.remove(at: orig.item)
        sizes.insert(size, at:prop.item)
        for (ix,size) in sizes.enumerated() {
            self.sections[orig.section].itemData[ix].size = size
        }
        return prop
    }

    

}
