

import UIKit

@objc protocol Dummy {
    func dummy(_ sender:AnyObject?)
}


class MyTextField: UITextField {
    
    // make self-dismissing; can do this without code, but just testing
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.addTarget(
            nil, action:#selector(Dummy.dummy), for:.editingDidEndOnExit)
    }
    
    // func dummy(_:AnyObject) {}
    
    let list : [String] = {
        let path = Bundle.main.url(forResource:"abbreviations", withExtension:"txt")!
        let s = try! String(contentsOf:path)
        return s.components(separatedBy:"\n")
        }()
    
    func state(forAbbrev abbrev:String) -> String? {
        let ix = self.list.index(of:abbrev.uppercased())
        return ix != nil ? list[ix!+1] : nil
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(expand), let r = self.selectedTextRange,
            let s = self.text(in:r) {
            return s.characters.count == 2 && self.state(forAbbrev:s) != nil
        }
        return super.canPerformAction(action, withSender:sender)
    }
    
    func expand(_ sender:AnyObject?) {
        if let r = self.selectedTextRange, let s = self.text(in:r),
            let ss = self.state(forAbbrev:s) {
            self.replace(r, withText:ss)
        }
    }
    
    override func copy(_ sender:Any?) {
        super.copy(sender)
        let pb = UIPasteboard.general
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
            let loc = self.offset(from:self.beginningOfDocument,
                                  to:r.start)
            let len = self.offset(from:r.start,
                                  to:r.end)
            return NSMakeRange(loc,len)
        } else {
            return NSMakeRange(0,0)
        }
    }
    set (r) {
        let st = self.position(from:self.beginningOfDocument,
            offset:r.location)!
        let en = self.position(from:self.beginningOfDocument,
            offset:r.location + r.length)!
        self.selectedTextRange = self.textRange(from:st, to:en)
    }
    }
}


