

import UIKit

/*
I've provided two independent versions of this example, one Swift, one Objective-C,
because the Swift version is prohibitively slow (especially on a device)
*/

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

        self.navigationItem.title = "States"
        let bb = UIBarButtonItem(title:"Push", style:.plain, target:self, action:#selector(doPush))
        self.navigationItem.rightBarButtonItem = bb
        self.collectionView!.backgroundColor = .white
        self.collectionView!.allowsMultipleSelection = true
        
        // register cell, comes from a nib even though we are using a storyboard
        self.collectionView!.register(UINib(nibName:"Cell", bundle:nil), forCellWithReuseIdentifier:self.cellID)
        // register headers (for the other view controller!)
        self.collectionView!.register(UICollectionReusableView.self,
            forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: self.headerID)

        // no supplementary views or anything
        
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
                v.addConstraints(
                    NSLayoutConstraint.constraints(withVisualFormat:"H:|-10-[lab(35)]",
                        metrics:nil, views:["lab":lab]))
                v.addConstraints(
                    NSLayoutConstraint.constraints(withVisualFormat:"V:[lab(30)]-5-|",
                        metrics:nil, views:["lab":lab]))
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = self.sections[indexPath.section].sectionName
        }
        return v
    }
    
    // cells
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:self.cellID, for: indexPath) as! Cell
        if cell.lab.text == "Label" { // new cell
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 2
            
            cell.backgroundColor = .gray
            
            /*
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
 */
            
            //            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
            //            let con = UIGraphicsGetCurrentContext()!
            //            let shadow = NSShadow()
            //            shadow.shadowColor = UIColor.darkGray()
            //            shadow.shadowOffset = CGSize(2,2)
            //            shadow.shadowBlurRadius = 4
            //            let check2 =
            //            AttributedString(string:"\u{2714}", attributes:[
            //                .font: UIFont(name:"ZapfDingbatsITC", size:24)!,
            //                .foregroundColor: UIColor.green(),
            //                .strokeColor: UIColor.red(),
            //                .strokeWidth: -4,
            //                .shadow: shadow
            //                ])
            //            con.scale(x:1.1, y:1)
            //            check2.draw(at:CGPoint(2,0))
            //            let im = UIGraphicsGetImageFromCurrentImageContext()!
            //            UIGraphicsEndImageContext()

            // let iv = UIImageView(image:nil, highlightedImage:im)
//            iv.isUserInteractionEnabled = false
//            cell.addSubview(iv)
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
    
    @objc func doPush(_ sender: Any?) {
        self.performSegue(withIdentifier:"push", sender: self)
    }
    
}

extension ViewController : UICollectionViewDelegateFlowLayout {
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
}
