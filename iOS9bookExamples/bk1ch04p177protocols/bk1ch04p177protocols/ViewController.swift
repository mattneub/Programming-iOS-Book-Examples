

import UIKit

protocol Flier {
    func fly()
}
struct Bird : Flier {
    func fly() {
    }
    func getWorm() {
    }
}
struct Bee {
    func fly() {
    }
}
func tellToFly(f:Flier) {
    f.fly()
}
enum Filter : String, CustomStringConvertible {
    case Albums = "Albums"
    case Playlists = "Playlists"
    case Podcasts = "Podcasts"
    case Books = "Audiobooks"
    var description : String { return self.rawValue }
}
func isBird(f:Flier) -> Bool {
    return f is Bird
}
func tellGetWorm(f:Flier) {
    (f as? Bird)?.getWorm()
}
struct Insect : Flier {
    func fly() {
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let b = Bird()
        tellToFly(b)
        let b2 = Bee()
        // tellToFly(b2) // compile error
        
        let type = Filter.Albums
        print(type) // Albums
        print("It is \(type)") // It is Albums
        
        let ok = isBird(Bird())
        print(ok)
        let ok2 = isBird(Insect())
        print(ok2)

        _ = b2
    
    }


}

