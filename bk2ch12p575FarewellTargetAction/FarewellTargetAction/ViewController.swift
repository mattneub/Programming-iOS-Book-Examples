
import UIKit

extension UIControl {
    func addAction(for event: UIControl.Event, handler: @escaping UIActionHandler) {
        self.addAction(UIAction(handler:handler), for:event)
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class Test: NSObject {
    @objc func test() {
        print("test")
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    let test = Test()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addAction(for: .touchUpInside) { action in
            print("howdy!")
        }
        
        button.addAction(.init {action in
            print("Your \(type(of:action.sender!)) is calling you!")
        }, for: .touchUpInside)
        
        // that's so freaking ugly, I've written an extension
        
        button.addAction(for: .touchUpInside) { action in
            print("This is so much nicer! Thanks", type(of:action.sender!))
        }
        
        print(button.allControlEvents) // yup, those are listed
        
        
        let action = UIAction { action in
            print("whoa")
        }
        button.removeAction(action, for: .touchUpInside)
        button.sendAction(action)
        
        // is a _normal_ action in the same list?
        button.addTarget(self, action: #selector(oldFashionedAction), for: .touchUpInside)
        button.addTarget(self.test, action: #selector(Test.test), for: .touchUpInside)
        delay(1) {
            self.button.sendActions(for: .touchUpInside)
        }
        
        // only the old target-action type of actions are part of these
        print(button.allTargets)
        print(button.actions(forTarget: self, forControlEvent: .touchUpInside))

        // so how do we introspect the UIActions? like this:
        button.enumerateEventHandlers { action, pair, event, stop in
            print("====")
            print(action)
            print(pair)
            print(event)
            print("----")
            print("got an action for", event)
            if action != nil {
                print("This one is a UIAction")
            }
            if pair != nil {
                print("This one is a target–action and the target is", pair!.0)
            }
        }
    }

    @objc func oldFashionedAction() {
        print("I'm just an old fashioned action")
    }

}

