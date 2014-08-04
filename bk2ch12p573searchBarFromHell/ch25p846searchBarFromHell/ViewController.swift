

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var sb : UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sb.searchBarStyle = .Default
        self.sb.barStyle = .Default
        self.sb.translucent = true
        self.sb.barTintColor = UIColor.greenColor() // unseen in this example
        // self.sb.backgroundColor = UIColor.redColor()
        
        let lin = UIImage(named:"linen.png")
        let linim = lin.resizableImageWithCapInsets(UIEdgeInsetsMake(1,1,1,1), resizingMode:.Stretch)
        self.sb.setBackgroundImage(linim, forBarPosition:.Any, barMetrics:.Default)
        self.sb.setBackgroundImage(linim, forBarPosition:.Any, barMetrics:.DefaultPrompt)
        
        let sep = UIImage(named:"sepia.jpg")
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(320,20), false, 0)
        UIBezierPath(roundedRect:CGRectMake(5,0,320-5*2,20), cornerRadius:8).addClip()
        sep.drawInRect(CGRectMake(0,0,320,20))
        let sepim = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.sb.setSearchFieldBackgroundImage(sepim, forState:.Normal)
        // just to show what it does:
        self.sb.searchFieldBackgroundPositionAdjustment = UIOffsetMake(0, -10) // up from center
        
        // how to reach in and grab the text field
        for v in (self.sb.subviews[0] as UIView).subviews as [UIView] {
            if v is UITextField {
                println("got that puppy")
                let tf = v as UITextField
                tf.textColor = UIColor.whiteColor()
                break
            }
        }
        
        self.sb.text = "Search me!"
        //    self.sb.showsBookmarkButton = true
        //    self.sb.showsSearchResultsButton = true
        //    self.sb.searchResultsButtonSelected = true
        
        let manny = UIImage(named:"manny.jpg")
        self.sb.setImage(manny, forSearchBarIcon:.Search, state:.Normal)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20,20), true, 0)
        manny.drawInRect(CGRectMake(0,0,20,20))
        let mannyim = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.sb.setImage(mannyim, forSearchBarIcon:.Clear, state:.Normal)
        
        let moe = UIImage(named:"moe.jpg")
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20,20), true, 0)
        moe.drawInRect(CGRectMake(0,0,20,20))
        let moeim = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.sb.setImage(moeim, forSearchBarIcon:.Clear, state:.Highlighted)
        
        self.sb.showsScopeBar = true
        self.sb.scopeButtonTitles = ["Manny", "Moe", "Jack"]
        
        self.sb.scopeBarBackgroundImage = UIImage(named:"sepia.jpg")
        
        self.sb.setScopeBarButtonBackgroundImage(linim, forState:.Normal)

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(2,2), true, 0)
        UIColor.whiteColor().setFill()
        UIBezierPath(rect:CGRectMake(0,0,2,2)).fill()
        let divim = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.sb.setScopeBarButtonDividerImage(divim, forLeftSegmentState:.Normal, rightSegmentState:.Normal)

        let shad = NSShadow()
        shad.shadowColor = UIColor.grayColor()
        shad.shadowOffset = CGSizeMake(2,2)
        let atts = [
            NSFontAttributeName: UIFont(name:"GillSans-Bold", size:16),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSShadowAttributeName: shad,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleDouble.toRaw()
        ]
        self.sb.setScopeBarButtonTitleTextAttributes(atts, forState:.Normal)
        self.sb.setScopeBarButtonTitleTextAttributes(atts, forState:.Selected)
        
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        searchBar.resignFirstResponder()
    }
}
