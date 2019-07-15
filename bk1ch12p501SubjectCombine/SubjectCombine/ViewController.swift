
import UIKit
import Combine

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pass = PassthroughSubject<String,Never>()
        let curr = CurrentValueSubject<String,Never>("bonjour")

        
        let sink = pass.sink { print($0) }
        pass.send("howdy")
        // sink.cancel()
        
        _ = curr.sink { print($0) } // causes initial value to be sent
        curr.send("allo allo") // one way
        curr.value = ("au revoir") // another way, but I doubt you're supposed to do that
        
        let ps2 = PassthroughSubject<String,Never>()
        _ = ps2.sink{ print($0) }
        // must capture the result or we won't operate
        let subscription = pass.subscribe(ps2)
        pass.send("mannie")
        pass.send("moe")
        pass.send("jack")
        subscription.cancel()
        
        pass.send("done") // silence

    }


}

