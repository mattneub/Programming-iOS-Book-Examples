

import UIKit

let list : [String] = {
    let path = NSBundle.mainBundle().URLForResource("abbreviations", withExtension:"txt")
    let s = NSString(contentsOfURL:path, encoding:NSUTF8StringEncoding, error:nil)
    return s.componentsSeparatedByString("\n") as [String]
}()

class MyTextField: UITextField {
    
    class func stateForAbbrev(abbrev:String) -> String? {
        let ix = find(list, abbrev.uppercaseString)
        return ix != nil ? list[ix!+1] : nil
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
        if action == "expand:" {
            if let s = self.textInRange(self.selectedTextRange) {
                return ( countElements(s) == 2 && self.dynamicType.stateForAbbrev(s) != nil )
            }
        }
        return super.canPerformAction(action, withSender:sender)
    }
    
    func expand(sender:AnyObject) {
        if let s = self.textInRange(self.selectedTextRange) {
            if let ss = self.dynamicType.stateForAbbrev(s) {
                self.replaceRange(self.selectedTextRange, withText:ss)
            }
        }
    }
    
    override func copy(sender:AnyObject) {
        super.copy(sender)
        let pb = UIPasteboard.generalPasteboard()
        let s = pb.string
        // ... alter s here ...
        let ss = s + "surprise!"
        pb.string = ss
    }
    
    
}

extension UITextField { // is this legal? sure makes life better...
    var selectedRange : NSRange {
    get {
        let r : UITextRange = self.selectedTextRange
        let loc = self.offsetFromPosition(self.beginningOfDocument,
            toPosition:r.start)
        let len = self.offsetFromPosition(r.start,
            toPosition:r.end)
        return NSMakeRange(loc,len)
    }
    set (r) {
        let st : UITextPosition = self.positionFromPosition(self.beginningOfDocument,
            offset:r.location)
        let en : UITextPosition = self.positionFromPosition(self.beginningOfDocument,
            offset:r.location + r.length)
        self.selectedTextRange = self.textRangeFromPosition(st, toPosition:en)
    }
    }
}


