

import UIKit

// exploring types of where clause expression

// ==== colon and protocol

protocol Flier {
    associatedtype Other
}
struct Bird : Flier {
    typealias Other = String
}
struct Insect : Flier {
    typealias Other = Bird
}
// the convention now seems to be to put everything in the where clause
func flockTogether<T> (_ f:T) where T:Flier, T.Other:Equatable {}

// ==== colon and class

class Dog {
}
class NoisyDog : Dog {
}
struct Pig : Flier {
    typealias Other = Dog
}
struct Pig2 : Flier {
    typealias Other = NoisyDog
}
func flockTogether2<T> (_ f:T) where T:Flier, T.Other:Dog {}

// ==== equality and protocol

protocol Walker {
}
struct Kiwi : Walker {
}
struct Bird3 : Flier {
    typealias Other = Kiwi
}
struct Insect3 : Flier {
    typealias Other = Walker
}
func flockTogether3<T> (_ f:T) where T:Flier, T.Other == Walker {}

// ==== equality and class

func flockTogether4<T> (_ f:T) where T:Flier, T.Other == Dog {}

// ==== equality and two associated type chains

struct Bird4 : Flier {
    typealias Other = String
}
struct Insect4 : Flier {
    typealias Other = Int
}
func flockTwoTogether<T,U> (_ f1:T, _ f2:U)
    where T:Flier, U:Flier, T.Other == U.Other {}

// ==== with a struct (just testing the outside-the-angle-brackets syntax)

struct G<T> where T:Flier {}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        flockTogether(Bird()) // okay
        // flockTogether(Insect()) // nope
        
        flockTogether2(Pig()) // okay
        flockTogether2(Pig2()) // okay
        
        // flockTogether3(Bird3()) // nope
        flockTogether3(Insect3()) // okay
        
        flockTogether4(Pig()) // okay
        // flockTogether4(Pig2()) // nope
        
        flockTwoTogether(Bird4(), Bird4())
        flockTwoTogether(Insect4(), Insect4())
        // flockTwoTogether(Bird4(), Insect4()) // nope
        
        var s = "hello"
        s.append(contentsOf: " world") // "hello world"; character array
        print(s)
        s.append(contentsOf: ["!" as Character, "?" as Character])
        print(s) // "hello world!?"
        
        s = "hello"
        s.append(" world") // "hello world"
        print(s)

        
        var arr = ["manny", "moe"]
        arr.append(contentsOf: ["jack"])
        // arr.append(contentsOf: [1]) // nope
        
        
    }



}

