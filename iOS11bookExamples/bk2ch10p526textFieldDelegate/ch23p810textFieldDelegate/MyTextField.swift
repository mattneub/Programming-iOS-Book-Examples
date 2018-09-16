

import UIKit

@objc protocol Dummy {
    func dummy(_ sender: Any?)
}


class MyTextField: UITextField {
    
    // make self-dismissing; can do this without code, but just testing
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.addTarget(
            nil, action:#selector(Dummy.dummy), for:.editingDidEndOnExit)
    }
    
    
    let list : [String:String] = {
        let path = Bundle.main.url(forResource:"abbreviations", withExtension:"txt")!
        let s = try! String(contentsOf:path)
        let arr = s.components(separatedBy:"\n")
        var result : [String:String] = [:]
        stride(from: 0, to: arr.count, by: 2).map{($0,$0+1)}.forEach {
            result[arr[$0.0]] = arr[$0.1]
        }
        return result
    }()
    
    func state(for abbrev:String) -> String? {
        return self.list[abbrev.uppercased()]
    }
    

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(expand) {
            if let r = self.selectedTextRange, let s = self.text(in:r) {
                return (s.count == 2 && self.state(for:s) != nil)
            }
        }
        return super.canPerformAction(action, withSender:sender)
    }
    
    @objc func expand(_ sender: Any?) {
        if let r = self.selectedTextRange, let s = self.text(in:r) {
            if let ss = self.state(for:s) {
                self.replace(r, withText:ss)
            }
        }
    }
    
    override func copy(_ sender:Any?) {
        super.copy(sender)
        let pb = UIPasteboard.general
        if var s = pb.string {
            // ... alter s here ...
            // s = s + "surprise!"
            pb.string = s
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


