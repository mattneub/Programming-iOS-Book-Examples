

import UIKit

// exploring types of where clause expression

// ==== colon and protocol

protocol Flier {
    associatedtype T
}
struct Bird : Flier {
    typealias T = String
}
struct Insect : Flier {
    typealias T = Bird
}
// the convention now seems to be to put everything in the where clause
func flockTogether<T> (_ f:T) where T:Flier, T.T:Equatable {}

// ==== colon and class

class Dog {
}
class NoisyDog : Dog {
}
struct Cat {}
enum Bug {}
struct Pig : Flier {
    typealias T = Dog
}
struct Pig2 : Flier {
    typealias T = NoisyDog
}
func flockTogether2<T> (_ f:T) where T:Flier, T.T:Dog {}

// ==== equality and protocol

protocol Walker {
}
struct Kiwi : Walker {
}
struct Bird3 : Flier {
    typealias T = Kiwi
}
struct Insect3 : Flier {
    typealias T = Walker
}
func flockTogether3<T> (_ f:T) where T:Flier, T.T == Walker {}

// ==== equality and class

func flockTogether4<T> (_ f:T) where T:Flier, T.T == Dog {}

// ==== equality and two associated type chains

struct Bird4 : Flier {
    typealias T = String
}
struct Insect4 : Flier {
    typealias T = Int
}
func flockTwoTogether<U1,U2> (_ f1:U1, _ f2:U2)
    where U1:Flier, U2:Flier, U1.T == U2.T {}

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
        s.append(contentsOf: " there")
        s.append(contentsOf: " world")
        print(s)
        s.append(contentsOf: ["!" as Character, "?" as Character])
        print(s)
        // yeah nah
        // s.append(contentsOf: ("1" as Character)..<("9" as Character))
        
        var arr = ["manny", "moe"]
        arr.append(contentsOf: ["jack"])
        // arr.append(contentsOf: [1]) // nope
        
        
    }



}

