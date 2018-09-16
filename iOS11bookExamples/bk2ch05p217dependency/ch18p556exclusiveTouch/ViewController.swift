

import UIKit

class ViewController : UIViewController, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ g: UIGestureRecognizer, shouldRequireFailureOf og: UIGestureRecognizer) -> Bool {
        
        let enc : String.Encoding = .utf8
        let s1 = NSString(cString: object_getClassName(g), encoding: enc.rawValue)
        let s2 = NSString(format:"%p", g.view!)
        let s3 = NSString(cString: object_getClassName(og), encoding: enc.rawValue)
        let s4 = NSString(format:"%p", og.view!)
        
        // I'd rather not see these, thanks (interesting though)
        if s1 == "_UISystemGestureGateGestureRecognizer" { return false }
        if s3 == "_UISystemGestureGateGestureRecognizer" { return false }
        
        print("should \(s1 as Any) on \(s2) require failure of \(s3 as Any) on \(s4)")
        
        return false

        
    }
    
    func gestureRecognizer(_ g: UIGestureRecognizer, shouldBeRequiredToFailBy og: UIGestureRecognizer) -> Bool {
        
        let enc : String.Encoding = .utf8
        let s1 = NSString(cString: object_getClassName(g), encoding: enc.rawValue)
        let s2 = NSString(format:"%p", g.view!)
        let s3 = NSString(cString: object_getClassName(og), encoding: enc.rawValue)
        let s4 = NSString(format:"%p", og.view!)
        
        if s1 == "_UISystemGestureGateGestureRecognizer" { return false }
        
        print("should \(s1 as Any) on \(s2) be required to fail by \(s3 as Any) on \(s4)")
        
        return false
    }
    
}
