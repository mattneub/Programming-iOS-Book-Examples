
// this is not actually in the book...
// seems useful to have a Combine publisher for when a UIControl's action fires
// I don't understand why Apple has not built this in

import UIKit
import Combine

extension UIControl {
    func publisher() -> ControlPublisher {
        ControlPublisher(control:self)
    }
    struct ControlPublisher : Publisher {
        typealias Output = UIControl
        typealias Failure = Never
        unowned let control : UIControl
        init(control:UIControl) { self.control = control }
        func receive<S>(subscriber: S)
            where S : Subscriber,
            Never == S.Failure,
            Output == S.Input {
                subscriber.receive(subscription:
                    Inner(downstream: subscriber, sender: control))
        }
        // NSObject to make it readily hashable
        // so target can be stored coherently by control
        class Inner <S:Subscriber>: NSObject,
        Subscription where S.Input == UIControl {
            weak var sender : UIControl?
            let downstream : S?
            init(downstream: S, sender : UIControl) {
                self.downstream = downstream
                self.sender = sender
                super.init()
                self.sender?.addTarget(self, action: #selector(doAction),
                                       for: .primaryActionTriggered)
            }
            private func removeSender() {
                self.sender?.removeTarget(
                    self,
                    action: #selector(doAction),
                    for: .primaryActionTriggered)
                self.sender = nil
            }
            func request(_ demand: Subscribers.Demand) {
                if .max(0) == demand { self.removeSender() }
            }
            func cancel() {
                self.removeSender()
                Swift.print("cancel")
                // remarkably, canceling manually also releases the subscription
                // I don't know why, but that's good
            }
            @objc func doAction(_ sender:UIControl) {
                guard let sender = self.sender else {return}
                _ = self.downstream?.receive(sender)
                // no point examining result
                // testing shows it could be `.max(0)` which is wrong
            }
            deinit {
                self.removeSender()
                Swift.print("farewell from subscription")
            }
        }
    }
}




func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class Thing : NSObject {
    @objc func doAction(_ sender:UIControl) {
        print("doAction")
    }
}

class ViewController: UIViewController {
    
    var storage = Set<AnyCancellable>()
    
    var thing : Thing? = Thing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = UIButton(type: .system)
        button.setTitle("Testing", for: .normal)
        button.sizeToFit()
        button.frame.origin = CGPoint(x: 100, y: 100)
        self.view.addSubview(button)
        
        let pub = button.publisher()
            .scan(0){ i,_ in i+1 }
        pub.sink {print($0)}.store(in:&storage)
//        delay(10) { // testing manual cancellation
//            [weak self] in self?.storage.removeAll()
//        }
        
        // testing multiple target/action pairs
        button.addTarget(self.thing, action: #selector(Thing.doAction), for: .primaryActionTriggered)
        self.thing = nil
        
        // testing switch pairs as in TapTapFreeCell
        let s1 = UISwitch()
        let s2 = UISwitch()
        s1.frame.origin = CGPoint(x:100,y:200)
        s2.frame.origin = CGPoint(x:100,y:250)
        self.view.addSubview(s1)
        self.view.addSubview(s2)
        
        func pair(when s1:UISwitch, goes onOff:Bool, alsoDoThatTo s2:UISwitch) {
            s1.publisher()
                .compactMap { ($0 as? UISwitch)?.isOn }
                .filter { onOff ? $0 : !$0 }
                .sink{ s2.setOn($0, animated:true) }
                .store(in: &storage)
        }
        pair(when:s1, goes:false, alsoDoThatTo:s2)
        pair(when:s2, goes:true, alsoDoThatTo:s1)

    }
    
    
}

