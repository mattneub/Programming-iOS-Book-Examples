

import UIKit

// exploring types of where clause expression

// ==== colon and protocol

protocol Flier {
    typealias Other
}
struct Bird : Flier {
    typealias Other = String
}
struct Insect : Flier {
    typealias Other = Bird
}
func flockTogether<T:Flier where T.Other:Equatable> (f:T) {}

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
func flockTogether2<T:Flier where T.Other:Dog> (f:T) {}

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
func flockTogether3<T:Flier where T.Other == Walker> (f:T) {}

// ==== equality and class

func flockTogether4<T:Flier where T.Other == Dog> (f:T) {}

// ==== equality and two associated type chains

struct Bird4 : Flier {
    typealias Other = String
}
struct Insect4 : Flier {
    typealias Other = Int
}
func flockTwoTogether<T:Flier, U:Flier where T.Other == U.Other>
    (f1:T, _ f2:U) {}


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
        s.appendContentsOf(" world".characters) // "hello world"
        print(s)
        s.appendContentsOf(["!" as Character])
        print(s) // "hello world"
        
        var arr = ["mannie", "moe"]
        arr.appendContentsOf(["jack"])
        // arr.appendContentsOf([1]) // nope
        
        
    }



}

