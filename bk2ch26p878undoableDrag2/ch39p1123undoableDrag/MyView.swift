

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
        let p = UIPanGestureRecognizer(target: self, action: #selector(dragging))
        self.addGestureRecognizer(p)
        let l = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.addGestureRecognizer(l)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // invocation variant
    
    func setCenterUndoably (newCenter:CGPoint) { // *
        self.undoer.prepareWithInvocationTarget(self).setCenterUndoably(self.center) // *
        self.undoer.setActionName("Move")
        if self.undoer.undoing || self.undoer.redoing {
            print("undoing or redoing")
            UIView.animateWithDuration(0.4, delay: 0.1, options: [], animations: {
                self.center = newCenter // *
            }, completion: nil)
        } else {
            // just do it
            print("just do it")
            self.center = newCenter // *
        }
    }
    
    func dragging (p : UIPanGestureRecognizer) {
        switch p.state {
        case .Began:
            self.undoer.beginUndoGrouping()
            fallthrough
        case .Began, .Changed:
            let delta = p.translationInView(self.superview!)
            var c = self.center
            c.x += delta.x; c.y += delta.y
            self.setCenterUndoably(c) // *
            p.setTranslation(CGPointZero, inView: self.superview!)
        case .Ended, .Cancelled:
            self.undoer.endUndoGrouping()
            self.becomeFirstResponder()
        default:break
        }
    }
    
    // ===== press-and-hold, menu

    func longPress (g : UIGestureRecognizer) {
        if g.state == .Began {
            let m = UIMenuController.sharedMenuController()
            m.setTargetRect(self.bounds, inView: self)
            let mi1 = UIMenuItem(title: self.undoer.undoMenuItemTitle, action: #selector(undo))
            let mi2 = UIMenuItem(title: self.undoer.redoMenuItemTitle, action: #selector(redo))
            m.menuItems = [mi1, mi2]
            m.setMenuVisible(true, animated:true)
        }
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
        if action == #selector(undo) {
            return self.undoer.canUndo
        }
        if action == #selector(redo) {
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
