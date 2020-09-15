
import UIKit

protocol Named {
    var name : String {get set}
}
struct Person : Named {
    var name : String
}

func namedMaker(_ name: String) -> some Named {
    return Person(name:name)
}

func haveSameName<T:Named>(_ named1:T, _ named2:T) -> Bool {
    return named1.name == named2.name
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let matt = Person(name: "Matt")
        let ethan = Person(name: "Ethan")
        let ok = haveSameName(matt,ethan) // fine
        
        do {
            let named1 : Named = Person(name: "Matt")
            let named2 : Named = Person(name: "Ethan")
            // let ok = haveSameName(named1, named2) // compile error
            _ = (named1, named2)
        }
        
        do {
            let named1 = namedMaker("Matt")
            let named2 = namedMaker("Ethan")
            let ok = haveSameName(named1, named2) // fine
            _ = ok
        }
        
        _ = ok
    }


}

