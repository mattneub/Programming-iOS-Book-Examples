
import UIKit

class ViewController: UIViewController {
    
    // this code comes straight from the docs (proposal)
    // just testing the compiler to see how it responds
    // to implicit promotion of function type
    
    struct FunctionTypes {
      var syncNonThrowing: () -> Void
      var syncThrowing: () throws -> Void
      var asyncNonThrowing: () async -> Void
      var asyncThrowing: () async throws -> Void
      
      mutating func demonstrateConversions() {
        // Okay to add 'async' and/or 'throws'
        asyncNonThrowing = syncNonThrowing
        asyncThrowing = syncThrowing
        syncThrowing = syncNonThrowing
        asyncThrowing = asyncNonThrowing
        
        // Error to remove 'async' or 'throws'
        syncNonThrowing = asyncNonThrowing // error
        syncThrowing = asyncThrowing       // error
        syncNonThrowing = syncThrowing     // error
        asyncNonThrowing = syncThrowing    // error
      }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

