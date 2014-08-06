import UIKit

class MyTextContainer : NSTextContainer {
    
    override func lineFragmentRectForProposedRect(proposedRect: CGRect, atIndex characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remainingRect: UnsafeMutablePointer<CGRect>) -> CGRect {
        
        var result = super.lineFragmentRectForProposedRect(proposedRect, atIndex:characterIndex, writingDirection:baseWritingDirection, remainingRect:remainingRect)
        
        let r = CGRectMake(0,0,self.size.width,self.size.height)
        let circle = UIBezierPath(ovalInRect:r)
        
        while !circle.containsPoint(result.origin) {
            result.origin.x += 0.1
        }
        
        while !circle.containsPoint(CGPointMake(result.maxX, result.origin.y)) {
            result.size.width -= 0.1
        }
        
        return result

    }
    
}
