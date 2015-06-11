

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
enum ListType : String, Printable {
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




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let b = Bird()
        tellToFly(b)
        let b2 = Bee()
        // tellToFly(b2) // compile error
        
        let type = ListType.Albums
        println(type) // Albums


    
    }


}

