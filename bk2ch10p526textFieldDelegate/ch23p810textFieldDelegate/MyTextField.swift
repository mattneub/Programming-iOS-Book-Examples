

import UIKit


class MyTextField: UITextField {
    
    let list : [String] = {
        let path = NSBundle.mainBundle().URLForResource("abbreviations", withExtension:"txt")!
        let s = try! String(contentsOfURL:path, encoding:NSUTF8StringEncoding)
        return s.componentsSeparatedByString("\n")
        }()
    
    func stateForAbbrev(abbrev:String) -> String? {
        let ix = self.list.indexOf(abbrev.uppercaseString)
        return ix != nil ? list[ix!+1] : nil
    }
    
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == "expand:", let r = self.selectedTextRange,
            let s = self.textInRange(r) {
                return s.characters.count == 2 && self.stateForAbbrev(s) != nil
        }
        return super.canPerformAction(action, withSender:sender)
    }
    
    func expand(sender:AnyObject?) {
        if let r = self.selectedTextRange, let s = self.textInRange(r),
            let ss = self.stateForAbbrev(s) {
                self.replaceRange(r, withText:ss)
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
            offset:r.location)!
        let en = self.positionFromPosition(self.beginningOfDocument,
            offset:r.location + r.length)!
        self.selectedTextRange = self.textRangeFromPosition(st, toPosition:en)
    }
    }
}


