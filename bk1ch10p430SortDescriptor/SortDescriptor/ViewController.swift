
import UIKit

@objcMembers
class Person : NSObject {
    let firstName : String
    let lastName : String
    internal init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    override var description : String {
        self.firstName + " " + self.lastName
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let people : [Person] = [
            Person(firstName: "Harpo", lastName: "Marx"),
            Person(firstName: "Moe", lastName: "Pep"),
            Person(firstName: "Groucho", lastName: "Marx"),
            Person(firstName: "Manny", lastName: "Pep")
        ]
        let sort1 = SortDescriptor(\Person.lastName)
        let sort2 = SortDescriptor(\Person.firstName)
        let result = people.sorted(using: [sort1, sort2])
        // [Groucho Marx, Harpo Marx, Manny Pep, Moe Pep]
        print(result)

        do {
            let sort1 = SortDescriptor(\Person.lastName)
            let sort2 = SortDescriptor(\Person.firstName, order: .reverse)
            let result = people.sorted(using: [sort1, sort2])
            // [Harpo Marx, Groucho Marx, Moe Pep, Manny Pep]
            print(result)
        }
    }


}

