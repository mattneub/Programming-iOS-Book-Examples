

import UIKit

func optionalExpecter(s:String?) {}
func realStringExpecter(s:String) {}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var stringMaybe = Optional("howdy")
        stringMaybe = Optional("farewell")
        // stringMaybe = Optional(123) // compile error
        stringMaybe = "farewell" // wrapped implicitly as it is assigned

        var stringMaybe2 : String? = "howdy"
        
        optionalExpecter(stringMaybe)
        optionalExpecter("howdy") // wrapped implicitly as it is passed

        // realStringExpecter(stringMaybe) // compile error, no implicit unwrapping
        realStringExpecter(stringMaybe!)
        
        // let upper = stringMaybe.uppercaseString // compile error
        let upper = stringMaybe!.uppercaseString

        var stringMaybe3 : ImplicitlyUnwrappedOptional<String> = "howdy"
        realStringExpecter(stringMaybe3) // no problem
        var stringMaybe4 : String! = "howdy"
        realStringExpecter(stringMaybe4)

        var stringMaybe5 : String? = "Howdy"
        println(stringMaybe5) // Optional("Howdy")
        if stringMaybe5 == nil {
            println("it is empty") // does not print
        }
        stringMaybe5 = nil
        println(stringMaybe5) // nil
        if stringMaybe5 == nil {
            println("it is empty") // prints
        }

        var stringMaybe6 : String?
        optionalExpecter(stringMaybe6) // legal because of implicit initialization
        let s = stringMaybe6! // crash!


    
    }



}

