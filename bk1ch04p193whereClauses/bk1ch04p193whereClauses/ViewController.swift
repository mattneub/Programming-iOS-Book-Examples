

import UIKit

protocol Flier {
}
protocol Walker {
}
protocol FlierWalker {
    typealias T : Flier, Walker // T must adopt Flier and Walker
}
func flyAndWalk<T where T:Walker, T:Flier> (f:T) {}

protocol Flier2 {
    typealias Other
}
struct Bird2 : Flier2 {
    typealias Other = String
}
struct Insect2 : Flier2 {
    typealias Other = Bird2
}
func flockTogether<T:Flier2 where T.Other:Equatable> (f:T) {}

func printc<C : CollectionType where C.Generator.Element == Character>(c:C) {
    for char in c {
        println(char)
    }
}

protocol Flier3 {
    typealias Other
}
struct Bird3 : Flier {
    typealias Other = String
}
struct Insect3 : Flier3 {
    typealias Other = Int
}
func flockTwoTogether<T:Flier3, U:Flier3 where T.Other == U.Other>
    (f1:T, f2:U) {}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        printc("howdy")
        printc(["h" as Character, "i" as Character])

    }


}

