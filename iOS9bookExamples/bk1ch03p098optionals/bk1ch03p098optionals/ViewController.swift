

import UIKit

func optionalExpecter(s:String?) { print(s) }
func realStringExpecter(s:String) {}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var stringMaybe = Optional("howdy")
        stringMaybe = Optional("farewell")
        // stringMaybe = Optional(123) // compile error
        stringMaybe = "farewell" // wrapped implicitly as it is assigned

        let stringMaybe2 : String? = "howdy"
        
        optionalExpecter(stringMaybe)
        optionalExpecter("howdy") // wrapped implicitly as it is passed

        // realStringExpecter(stringMaybe) // compile error, no implicit unwrapping
        realStringExpecter(stringMaybe!)
        
        // let upper = stringMaybe.uppercaseString // compile error
        let upper = stringMaybe!.uppercaseString

        let stringMaybe3 : ImplicitlyUnwrappedOptional<String> = "howdy"
        realStringExpecter(stringMaybe3) // no problem
        let stringMaybe4 : String! = "howdy"
        realStringExpecter(stringMaybe4)

        var stringMaybe5 : String? = "Howdy"
        print(stringMaybe5) // Optional("Howdy")
        if stringMaybe5 == nil {
            print("it is empty") // does not print
        }
        stringMaybe5 = nil
        print(stringMaybe5) // nil
        if stringMaybe5 == nil {
            print("it is empty") // prints
        }

        var crash : Bool {return false}
        if crash {
            var stringMaybe6 : String?
            optionalExpecter(stringMaybe6) // legal because of implicit initialization
            let s = stringMaybe6! // crash!
            _ = s
            _ = stringMaybe6
            stringMaybe6 = "howdy"
        }
        
        let stringMaybe7 : String?
        // optionalExpecter(stringMaybe7) // compile error; can't do that with a `let`
        
        do {
            var stringMaybe : String?
            // ... stringMaybe might be assigned a real value here ...
            if stringMaybe != nil {
                let s = stringMaybe!
                // ...
                _ = s
            }
            
            // shut the compiler up
            stringMaybe = "howdy"
        }


        // shut the compiler up
        _ = stringMaybe
        _ = stringMaybe2
        _ = stringMaybe3
        _ = stringMaybe4
        _ = stringMaybe5
        _ = upper
        stringMaybe7 = "howdy"
        _ = stringMaybe7
    
    }



}

