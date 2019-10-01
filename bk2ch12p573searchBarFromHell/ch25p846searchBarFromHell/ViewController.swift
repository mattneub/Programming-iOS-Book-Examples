

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


func imageOfSize(_ size:CGSize, closure:() -> ()) -> UIImage {
    let r = UIGraphicsImageRenderer(size:size)
    return r.image {
        _ in closure()
    }
}

//    UIGraphicsBeginImageContextWithOptions(size, false, 0)
//    closure()
//    let result = UIGraphicsGetImageFromCurrentImageContext()!
//    UIGraphicsEndImageContext()
//    return result


func lend<T> (closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
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

extension UIView {
    func firstSubview<T:UIView>(ofType WhatType:T.Type) -> T? {
        for sub in self.subviews {
            if let v = self as? T { return v }
            if let v = sub.firstSubview(ofType:WhatType) { return v }
        }
        return nil
    }
    func subviews<T:UIView>(ofType WhatType:T.Type) -> [T] {
        var result = self.subviews.compactMap {$0 as? T}
        for sub in self.subviews {
            result.append(contentsOf: sub.subviews(ofType:WhatType))
        }
        return result
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var sb : UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sb.enablesReturnKeyAutomatically = false // true by default, even though unchecked!

        self.sb.searchBarStyle = .default
        self.sb.barStyle = .default
        self.sb.isTranslucent = true
        self.sb.barTintColor = .green // unseen in this example
        // self.sb.backgroundColor = .red
        
        let lin = UIImage(named:"linen.png")!
        let linim = lin.resizableImage(withCapInsets:UIEdgeInsets(top: 1,left: 1,bottom: 1,right: 1), resizingMode:.stretch)
        self.sb.setBackgroundImage(linim, for:.any, barMetrics:.default)
        self.sb.setBackgroundImage(linim, for:.any, barMetrics:.defaultPrompt)
        
        let sepim = imageOfSize(CGSize(320,20)) {
            UIBezierPath(roundedRect:CGRect(5,0,320-5*2,20), cornerRadius:8).addClip()
            UIImage(named:"sepia.jpg")!.draw(in:CGRect(0,0,320,20))
        }
        self.sb.setSearchFieldBackgroundImage(sepim, for:.normal)
        // just to show what it does:
        self.sb.searchFieldBackgroundPositionAdjustment = UIOffset(horizontal: 0, vertical: -10) // up from center
        
        // at last! new in iOS 13
        if #available(iOS 13.0, *) {
            let tf = self.sb.searchTextField
            tf.textColor = .white
            // tf.isEnabled = false
        }
        
        self.sb.text = "Search me!"
        //self.sb.placeholder = "Search me!"
        //    self.sb.showsBookmarkButton = true
        //    self.sb.showsSearchResultsButton = true
        //    self.sb.searchResultsButtonSelected = true
        
        let manny = UIImage(named:"manny.jpg")!
        let mannyim = imageOfSize(CGSize(20,20)) {
            manny.draw(in:CGRect(0,0,20,20))
        }
        self.sb.setImage(mannyim, for:.clear, state:.normal)
        self.sb.setImage(mannyim, for:.search, state:.normal)
        
        let moe = UIImage(named:"moe.jpg")!
        let moeim = imageOfSize(CGSize(20,20)) {
            moe.draw(in:CGRect(0,0,20,20))
        }
        self.sb.setImage(moeim, for:.clear, state:.highlighted)
        
        self.sb.showsScopeBar = true
        self.sb.scopeButtonTitles = ["Manny", "Moe", "Jack"]
        
        self.sb.scopeBarBackgroundImage = UIImage(named:"sepia.jpg")
        
        self.sb.setScopeBarButtonBackgroundImage(linim, for:.normal)
        // great, but the problem is we have no indication of selection
        // need a selected image
//        let lin = UIImage(named:"linen.png")!
//        let linim = lin.resizableImage(withCapInsets:UIEdgeInsets(top: 1,left: 1,bottom: 1,right: 1), resizingMode:.stretch)
        let linimdark = imageOfSize(lin.size) {
            let con = UIGraphicsGetCurrentContext()!
            con.setFillColor(UIColor.black.cgColor)
            con.fill(CGRect(origin:.zero, size:lin.size))
            lin.draw(at: .zero, blendMode: .copy, alpha: 0.6)
        }.resizableImage(withCapInsets:UIEdgeInsets(top: 1,left: 1,bottom: 1,right: 1), resizingMode:.stretch)
        self.sb.setScopeBarButtonBackgroundImage(linimdark, for:.selected)
        // self.sb.setScopeBarButtonBackgroundImage(linimdark, for:.highlighted)

        let divim = imageOfSize(CGSize(2,2)) {
            UIColor.white.setFill()
            UIBezierPath(rect:CGRect(0,0,2,2)).fill()
        }
        self.sb.setScopeBarButtonDividerImage(divim,
            forLeftSegmentState:.normal, rightSegmentState:.normal)

        let atts : [NSAttributedString.Key : Any] = [
            .font: UIFont(name:"GillSans-Bold", size:16)!,
            .foregroundColor: UIColor.white,
//            .shadow: lend {
//                (shad:NSShadow) in
//                shad.shadowColor = UIColor.black
//                shad.shadowOffset = CGSize(2,2)
//            },
            .underlineStyle: NSUnderlineStyle.double.rawValue
        ]
        // The shadow is broken in iOS 12! still broken in iOS 13
        // I had to comment it out
        self.sb.setScopeBarButtonTitleTextAttributes(atts, for:.normal)
        // unclear what this next line was supposed to do for me
        // self.sb.setScopeBarButtonTitleTextAttributes(atts, for:.selected)
        
        dont: do {
            if #available(iOS 13.0, *) {
                break dont
                let tf = self.sb.searchTextField
                let token = UISearchToken(icon:nil, text:"Manny")
                tf.insertToken(token, at:0) // try 1, you'll crash
                print(tf.textualRange)

            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("selected", selectedScope)
    }
}
