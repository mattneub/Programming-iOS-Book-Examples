

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    actor MyActor {
        let id = UUID().uuidString // random unique identifier
        var myProperty: String
        init(_ myProperty: String) {
            self.myProperty = myProperty
        }
        func changeMyProperty(to newValue: String) {
            self.myProperty = newValue
        }
    }
    actor MyActor2 {
        let id = UUID().uuidString // random unique identifier
        @MainActor var myProperty: String
        init(_ myProperty: String) {
            self.myProperty = myProperty
        }
        @MainActor func changeMyProperty(to newValue: String) {
            self.myProperty = newValue
        }
    }

    func test() async {
        let act = MyActor("howdy")
        let id = act.id // legal
        let prop = await act.myProperty // legal but requires await
        await act.changeMyProperty(to: "hello") // legal but requires await
        // await act.myProperty = "hello" // compile error: illegal, even with await
    }

    func test2() {
        let act = MyActor2("howdy")
        act.changeMyProperty(to: "hello") // no problem
    }

}

