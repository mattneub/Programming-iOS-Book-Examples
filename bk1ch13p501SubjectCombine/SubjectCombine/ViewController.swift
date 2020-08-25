
import UIKit
import Combine

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {
    
    @Published var pub = "testing"
    let pass = PassthroughSubject<String,Never>()
    let curr = CurrentValueSubject<String,Never>("bonjour")
    var storage = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sink = self.pass.sink {
            print($0)
        }
        sink.store(in: &self.storage)
        delay(1) {
            self.pass.send("howdy")
        }
        
        // return; // uncomment to do the initial experiment
        sink.cancel() // done with this sink
        
        let sink2 = curr.sink {
            print($0)
        } // causes initial value to be sent
        curr.send("allo allo") // one way
        curr.value = ("au revoir") // another way, but I doubt you're supposed to do that
        
        let pass2 = PassthroughSubject<String,Never>()
        let sink3 = pass2.sink {
            print($0)
        }
        // must capture the result or we won't operate
        let cancellable = self.pass.subscribe(pass2) // a subject can subscribe to a subject
        self.pass.send("manny")
        self.pass.send("moe")
        self.pass.send("jack")
        cancellable.cancel()
        
        self.pass.send("done") // silence
        
        let sink4 = $pub.sink {
            print($0)
        }
        let sink5 = $pub.sink {
            print($0)
        }
        pub = "yoho"
        
        _ = (sink, sink2, sink3, sink4, sink5)
    }
    
    
}

