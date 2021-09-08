
import UIKit

// stuff from the Coolness framework, just to see what it does
// when not in a framework

/// Degree of coolness.
public enum Temp {
    /// So cool you could plotz.
    case frigid
    /// Kind of cool.
    case lukewarm
    /// Not particularly cool.
    case boiling
}


/// Expression of coolness.
public struct Cool {
    var temp : Temp
    
    /// Changes our coolness.
    /// - Parameter to: The ``Temp`` you'd like it to be.
    public mutating func changeTemp(to: Temp) {
        
    }
}


class ViewController: UIViewController {
    
    /**
     Many people would like to dog their cats. So it is *perfectly*
     reasonable to supply a convenience method to do so:
     
     * Because it's cool.
     * Because it's there.
     
     * parameter cats: A string containing cats
     
     * returns: A string containing dogs
     
     
     */

    func dogMyCats(_ cats:String) -> String {
        return "Dogs"
    }
    
    // interesting to add: * author: Who do you think?

    
    
    func anotherMethod(_ thing:String) -> Int { // select in this line,
        // generate documentation automatically
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let t = Temp.frigid
    }
    
    /*
     
     For spec, see https://developer.apple.com/library/mac/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html
     
     Other type 1 markers are: throws, 
     
     Other type 2 (description subgraf) markers are: Precondition, Postcondition, Requires, Invariant, Complexity, Important, Warning, Author, Authors, Copyright, Date, SeeAlso, Since, Version, Attention, Bug, Experiment, Note, Remark, ToDo
     
     Release notes also mention keyword, recommended, recommendedover, but I don't see them doing anything.
     
    */


}

