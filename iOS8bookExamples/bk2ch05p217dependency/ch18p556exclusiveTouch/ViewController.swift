

import UIKit

class ViewController : UIViewController, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(g: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer og: UIGestureRecognizer) -> Bool {
        
        let s1 = NSString(CString: object_getClassName(g), encoding: NSUTF8StringEncoding)
        let s2 = NSString(format:"%p", g.view!)
        let s3 = NSString(CString: object_getClassName(og), encoding: NSUTF8StringEncoding)
        let s4 = NSString(format:"%p", og.view!)
        
        // I'd rather not see these, thanks (interesting though)
        if s1 == "_UISystemGestureGateGestureRecognizer" { return false }
        if s3 == "_UISystemGestureGateGestureRecognizer" { return false }
        
        println("should \(s1) on \(s2) require failure of \(s3) on \(s4)")
        
        return false

        
    }
    
    func gestureRecognizer(g: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer og: UIGestureRecognizer) -> Bool {
        
        let s1 = NSString(CString: object_getClassName(g), encoding: NSUTF8StringEncoding)
        let s2 = NSString(format:"%p", g.view!)
        let s3 = NSString(CString: object_getClassName(og), encoding: NSUTF8StringEncoding)
        let s4 = NSString(format:"%p", og.view!)
        
        if s1 == "_UISystemGestureGateGestureRecognizer" { return false }
        
        println("should \(s1) on \(s2) be required to fail by \(s3) on \(s4)")
        
        return false
    }
    
}
