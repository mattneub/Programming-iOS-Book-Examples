

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
func tellToFly(_ f:Flier) {
    f.fly()
}
enum Filter : String, CustomStringConvertible {
    case albums = "Albums"
    case playlists = "Playlists"
    case podcasts = "Podcasts"
    case books = "Audiobooks"
    var description : String { return self.rawValue }
}
func isBird(_ f:Flier) -> Bool {
    return f is Bird
}
func tellGetWorm(_ f:Flier) {
    (f as? Bird)?.getWorm()
}
struct Insect : Flier {
    func fly() {
    }
}

func f(_ x: CustomStringConvertible & CustomDebugStringConvertible) {
    
}

protocol MyViewProtocol : class {
    func doSomethingCool()
}

class MyView : UIView, MyViewProtocol {
    func doSomethingCool() {}
}

extension UIButton : MyViewProtocol {
    func doSomethingCool() {}
}

class ViewController: UIViewController {
    
    var delegate : (UIView & MyViewProtocol)?

    override func viewDidLoad() {
        super.viewDidLoad()

        let b = Bird()
        tellToFly(b)
        let b2 = Bee()
        // tellToFly(b2) // compile error
        
        let type = Filter.albums
        print(type) // Albums
        print("It is \(type)") // It is Albums
        let s = String(describing:type) // Albums
        print(s)
        
        let ok = isBird(Bird())
        print(ok)
        let ok2 = isBird(Insect())
        print(ok2)

        _ = b2
        
        self.delegate = MyView()
        self.delegate = UIButton()
    
    }


}

