

import UIKit

class ViewController : UIViewController {
    
}

class MyView : UIView {
    
    let undoer = NSUndoManager()
    override var undoManager : NSUndoManager? {
        return self.undoer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let p = UIPanGestureRecognizer(target: self, action: "dragging:")
        self.addGestureRecognizer(p)
        let l = UILongPressGestureRecognizer(target: self, action: "longPress:")
        self.addGestureRecognizer(l)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // handler variant (new in iOS 9), better
    
    func dragging (p : UIPanGestureRecognizer) {
        switch p.state {
        case .Began:
            self.undoer.beginUndoGrouping()
            fallthrough
        case .Began, .Changed:
            let delta = p.translationInView(self.superview!)
            var c = self.center
            c.x += delta.x; c.y += delta.y
            func registerForUndo() {
                let oldCenter = self.center
                self.undoer.registerUndoWithTarget(self) {
                    v in
                    UIView.animateWithDuration(0.4, delay: 0.1, options: [], animations: {
                        v.center = oldCenter
                        }, completion: nil)
                    registerForUndo()
                }
                self.undoer.setActionName("Move")
            }
            registerForUndo()
            self.center = c // *
            p.setTranslation(CGPointZero, inView: self.superview!)
        case .Ended, .Cancelled:
            self.undoer.endUndoGrouping()
            self.becomeFirstResponder()
        default: break
        }
    }
    
    // ===== press-and-hold, menu

    func longPress (g : UIGestureRecognizer) {
        if g.state == .Began {
            let m = UIMenuController.sharedMenuController()
            m.setTargetRect(self.bounds, inView: self)
            let mi1 = UIMenuItem(title: self.undoer.undoMenuItemTitle, action: "undo:")
            let mi2 = UIMenuItem(title: self.undoer.redoMenuItemTitle, action: "redo:")
            m.menuItems = [mi1, mi2]
            m.setMenuVisible(true, animated:true)
        }
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
        if action == Selector("undo:") {
            return self.undoer.canUndo
        }
        if action == Selector("redo:") {
            return self.undoer.canRedo
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    func undo(_:AnyObject?) {
        self.undoer.undo()
    }
    
    func redo(_:AnyObject?) {
        self.undoer.redo()
    }
}
