
// just playing with various pointer features, purely experimental

import UIKit

class ViewController: UIViewController {
    //override var prefersPointerLocked: Bool { true }
    
    @IBOutlet weak var v: UIView!
    @IBOutlet weak var v2: UIView!
    
    override var canBecomeFirstResponder: Bool { true }
    
    // these do work on phone!
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        print("began", presses.map {$0.key})
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        print("ended", presses.map {$0.key})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        let comm = UIKeyCommand(title: "Try Me!", image: nil, action: #selector(tryMe), input: "k", modifierFlags: [.command, .shift, .control])
        // no target needed because we are adding this to the actual responder in question
        self.addKeyCommand(comm)
        // can't tell whether this can work on phone
        // Do any additional setup after loading the view.
        let hg = UIHoverGestureRecognizer(target: self, action: #selector(hover))
        
        let pg = UIPanGestureRecognizer(target: self, action: #selector(scroll))
        pg.allowedScrollTypesMask = .all // default is [], no scroll wheel
        //pg.allowedTouchTypes = [1] // prevent normal touch-drag, i.e. _only_ scroll wheel
        //pr.allowedTouchTypes = [3] // prevent finger, but pointer can drag and scroll
        print(pg.allowedTouchTypes)
        
        let tp = UITapGestureRecognizer(target: self, action: #selector(tap))
        
        let rg = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        
        tp.delegate = self
        hg.delegate = self
        pg.delegate = self
        rg.delegate = self
        
        // rg.allowedTouchTypes = [3] // filters out direct touches
        
        self.v.addGestureRecognizer(hg)
        self.v2.addGestureRecognizer(pg)
        self.view.addGestureRecognizer(tp)
        self.view.addGestureRecognizer(rg)



        

    }
    
    @objc func rotate(_ gr: UIRotationGestureRecognizer) {
        print("rotate", gr.numberOfTouches)
    }
    
    @objc func tryMe(_ what: UIKeyCommand) {
        print("you tried me!", what)
    }

    @objc func hover(_ gr: UIHoverGestureRecognizer) {
        switch gr.state {
        case .began: print("enter")
        case .changed: print("hovering")
        case .ended: print("exit")
        default: break
        }
    }
    
    @objc func scroll(_ gr: UIPanGestureRecognizer) {
        print("scroll", gr.translation(in: gr.view), gr.velocity(in: gr.view))
    }

    @objc func tap(_ gr: UITapGestureRecognizer) {
        let e = gr.buttonMask
        print(e)
        let m = gr.modifierFlags
        print(m)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        print(event)
        let count = event.allTouches?.count ?? 0
        if count == 2 {
            print("returning false")
            return false
        }
        return true
    }
}
