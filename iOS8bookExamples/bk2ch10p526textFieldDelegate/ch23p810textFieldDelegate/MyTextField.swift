

import UIKit


class MyTextField: UITextField {
    
    let list : [String] = {
        let path = NSBundle.mainBundle().URLForResource("abbreviations", withExtension:"txt")!
        let s = String(contentsOfURL:path, encoding:NSUTF8StringEncoding, error:nil)!
        return s.componentsSeparatedByString("\n")
        }()
    
    func stateForAbbrev(abbrev:String) -> String? {
        let ix = find(self.list, abbrev.uppercaseString)
        return ix != nil ? list[ix!+1] : nil
    }
    
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == "expand:" {
            if let r = self.selectedTextRange {
                let s = self.textInRange(r)
                return count(s) == 2 && self.stateForAbbrev(s) != nil
            }
            
        }
        return super.canPerformAction(action, withSender:sender)
    }
    
    func expand(sender:AnyObject?) {
        if let r = self.selectedTextRange {
            let s = self.textInRange(r)
            if let ss = self.stateForAbbrev(s) {
                self.replaceRange(r, withText:ss)
            }
        }
    }
    
    override func copy(sender:AnyObject?) {
        super.copy(sender)
        let pb = UIPasteboard.generalPasteboard()
        if let s = pb.string {
            // ... alter s here ...
            let ss = s + "surprise!"
            pb.string = ss
        }
    }
}

extension UITextField { // is this legal? sure makes life better...
    var selectedRange : NSRange {
    get {
        if let r = self.selectedTextRange {
            let loc = self.offsetFromPosition(self.beginningOfDocument,
                toPosition:r.start)
            let len = self.offsetFromPosition(r.start,
                toPosition:r.end)
            return NSMakeRange(loc,len)
        } else {
            return NSMakeRange(0,0)
        }
    }
    set (r) {
        let st = self.positionFromPosition(self.beginningOfDocument,
            offset:r.location)
        let en = self.positionFromPosition(self.beginningOfDocument,
            offset:r.location + r.length)
        self.selectedTextRange = self.textRangeFromPosition(st, toPosition:en)
    }
    }
}


