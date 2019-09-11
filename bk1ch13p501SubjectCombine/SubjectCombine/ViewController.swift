
import UIKit
import Combine

class ViewController: UIViewController {
    
    @Published var pub = "testing"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pass = PassthroughSubject<String,Never>()
        let curr = CurrentValueSubject<String,Never>("bonjour")

        
        let sink = pass.sink { print($0) }
        pass.send("howdy")
        sink.cancel() // done with this sink
        
        let sink2 = curr.sink { print($0) } // causes initial value to be sent
        curr.send("allo allo") // one way
        curr.value = ("au revoir") // another way, but I doubt you're supposed to do that
        
        let ps2 = PassthroughSubject<String,Never>()
        let sink3 = ps2.sink{ print($0) }
        // must capture the result or we won't operate
        let subscription = pass.subscribe(ps2)
        pass.send("mannie")
        pass.send("moe")
        pass.send("jack")
        subscription.cancel()
        
        pass.send("done") // silence

        let sink4 = $pub.sink { print($0) }
        let sink5 = $pub.sink { print($0) }
        pub = "yoho"

        _ = (sink, sink2, sink3, sink4, sink5)
    }


}

