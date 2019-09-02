

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



class ViewController : UICollectionViewController {
    
    struct Section {
        var sectionName : String
        var rowData : [String]
    }
    var sections : [Section]!

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    let headerID = "Header"
    
    override func viewDidLoad() {
        let s = try! String(
            contentsOfFile: Bundle.main.path(
                forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        let d = Dictionary(grouping: states) {String($0.prefix(1))}
        self.sections = Array(d).sorted{$0.key < $1.key}.map {
            Section(sectionName: $0.key, rowData: $0.value)
        }
        
        self.navigationItem.title = "States"
        
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerID)
        // if you don't do something about header size...
        // ...you won't see any headers
        let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.headerReferenceSize = CGSize(30,30)
        // still not working, layout is wrong
        // flow.estimatedItemSize = CGSize(30,100)
//        flow.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        flow.itemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].rowData.count
    }
    
    // minimal formatting; this is just to prove we can show the data at all
    
    // headers 
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var v : UICollectionReusableView! = nil
        if kind == UICollectionView.elementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerID, for: indexPath) 
            if v.subviews.count == 0 {
                v.addSubview(UILabel(frame:CGRect(0,0,30,30)))
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = self.sections[indexPath.section].sectionName
            lab.textAlignment = .center
        }
        return v
    }
    
    // cells
    
	let cellID = "Cell"
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) 
        if cell.contentView.subviews.count == 0 {
            let lab = UILabel(frame:CGRect(0,0,30,30))
            cell.contentView.addSubview(lab)
//            lab.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
//            lab.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
//            lab.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
//            lab.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
        }
        let lab = cell.contentView.subviews[0] as! UILabel
        lab.text = self.sections[indexPath.section].rowData[indexPath.row] // "item" synonym for "row"
        lab.sizeToFit()
        // cell.contentView.backgroundColor = .yellow
        return cell

    }
}

// but the above is not sufficient to see the entire name of a state
// the state names are curtailed; let's fix that
// adjust the size of each cell, as a UICollectionViewDelegateFlowLayout

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // note horrible duplication of code here
        let lab = UILabel(frame:CGRect(0,0,30,30))
        lab.text = self.sections[indexPath.section].rowData[indexPath.row]
        lab.sizeToFit()
        return lab.bounds.size
    }
}

// that duplication is exactly what iOS 8 is supposed to fix with _automatic_ variable cell size
// but I can't get that to work (see next example for my workaround using constraints)

// hey how long has this been going on????
// okay I can implement them but I don't see any index!
// looks like this is listed for iOS but actually only implemented on tvOS
extension ViewController {
    override func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return self.sections.map {$0.sectionName}
    }
    override func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        let sectionNames = self.sections.map {$0.sectionName}
        let ix = sectionNames.firstIndex(of: title)!
        return IndexPath(item: 0, section: ix)
    }
}
