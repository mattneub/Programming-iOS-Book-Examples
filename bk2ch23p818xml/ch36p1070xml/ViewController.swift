
import UIKit

class ViewController: UIViewController {
    
    // if this works, you'll see a list of people appear in the console

    @IBAction func doButton (_ sender:AnyObject!) {
        if let url = Bundle.main().urlForResource("folks", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: url) {
                let people = MyPeopleParser(name:"", parent:nil)
                parser.delegate = people
                parser.parse()
                
                // ... done, do something with people.people ...
                print(people.people)
            }
        }
    }


}
