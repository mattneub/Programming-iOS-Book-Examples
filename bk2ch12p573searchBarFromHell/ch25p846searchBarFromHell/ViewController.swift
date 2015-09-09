

import UIKit

func imageFromContextOfSize(size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController: UIViewController {
    
    @IBOutlet var sb : UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sb.enablesReturnKeyAutomatically = false // true by default, even though unchecked!

        self.sb.searchBarStyle = .Default
        self.sb.barStyle = .Default
        self.sb.translucent = true
        self.sb.barTintColor = UIColor.greenColor() // unseen in this example
        // self.sb.backgroundColor = UIColor.redColor()
        
        let lin = UIImage(named:"linen.png")!
        let linim = lin.resizableImageWithCapInsets(UIEdgeInsetsMake(1,1,1,1), resizingMode:.Stretch)
        self.sb.setBackgroundImage(linim, forBarPosition:.Any, barMetrics:.Default)
        self.sb.setBackgroundImage(linim, forBarPosition:.Any, barMetrics:.DefaultPrompt)
        
        let sepim = imageFromContextOfSize(CGSizeMake(320,20)) {
            UIBezierPath(roundedRect:CGRectMake(5,0,320-5*2,20), cornerRadius:8).addClip()
            UIImage(named:"sepia.jpg")!.drawInRect(CGRectMake(0,0,320,20))
        }
        self.sb.setSearchFieldBackgroundImage(sepim, forState:.Normal)
        // just to show what it does:
        self.sb.searchFieldBackgroundPositionAdjustment = UIOffsetMake(0, -10) // up from center
        
        // how to reach in and grab the text field
        for v in self.sb.subviews[0].subviews {
            if let tf = v as? UITextField {
                print("got that puppy")
                tf.textColor = UIColor.whiteColor()
                // tf.enabled = false
                break
            }
        }
        
        self.sb.text = "Search me!"
        //self.sb.placeholder = "Search me!"
        //    self.sb.showsBookmarkButton = true
        //    self.sb.showsSearchResultsButton = true
        //    self.sb.searchResultsButtonSelected = true
        
        let manny = UIImage(named:"manny.jpg")!
        self.sb.setImage(manny, forSearchBarIcon:.Search, state:.Normal)
        let mannyim = imageFromContextOfSize(CGSizeMake(20,20)) {
            manny.drawInRect(CGRectMake(0,0,20,20))
        }
        self.sb.setImage(mannyim, forSearchBarIcon:.Clear, state:.Normal)
        
        let moe = UIImage(named:"moe.jpg")!
        let moeim = imageFromContextOfSize(CGSizeMake(20,20)) {
            moe.drawInRect(CGRectMake(0,0,20,20))
        }
        self.sb.setImage(moeim, forSearchBarIcon:.Clear, state:.Highlighted)
        
        self.sb.showsScopeBar = true
        self.sb.scopeButtonTitles = ["Manny", "Moe", "Jack"]
        
        self.sb.scopeBarBackgroundImage = UIImage(named:"sepia.jpg")
        
        self.sb.setScopeBarButtonBackgroundImage(linim, forState:.Normal)

        let divim = imageFromContextOfSize(CGSizeMake(2,2)) {
            UIColor.whiteColor().setFill()
            UIBezierPath(rect:CGRectMake(0,0,2,2)).fill()
        }
        self.sb.setScopeBarButtonDividerImage(divim,
            forLeftSegmentState:.Normal, rightSegmentState:.Normal)

        let atts = [
            NSFontAttributeName: UIFont(name:"GillSans-Bold", size:16)!,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSShadowAttributeName: lend {
                (shad:NSShadow) in
                shad.shadowColor = UIColor.grayColor()
                shad.shadowOffset = CGSizeMake(2,2)
            },
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleDouble.rawValue
        ]
        self.sb.setScopeBarButtonTitleTextAttributes(atts, forState:.Normal)
        self.sb.setScopeBarButtonTitleTextAttributes(atts, forState:.Selected)
        
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
