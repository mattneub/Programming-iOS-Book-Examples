

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

protocol MyViewProtocol : AnyObject {
    func doSomethingCool()
}

protocol MyViewProtocol2 : UIView {
    func doSomethingReallyCool()
}

protocol MyOtherProtocol where Self: UIView {}
protocol MyOtherProtocol2 where Self: AnyObject {} // same as class
protocol MyOtherProtocol3: class {} // still legal

class MyView : UIView, MyViewProtocol {
    func doSomethingCool() {}
}

class MyView2 : UIView, MyViewProtocol2 {
    func doSomethingReallyCool() {}
}

class MyNonView : NSObject, MyViewProtocol /*, MyViewProtocol2 */ {
    func doSomethingCool() {}
    func doSomethingReallyCool() {}
}

extension UIButton : MyViewProtocol {
    func doSomethingCool() {}
}

class ViewController: UIViewController {
    
    var delegate : (UIView & MyViewProtocol)?
    var delegate2 : MyViewProtocol2?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate2?.doSomethingReallyCool() // it's a MyViewProtocol2
        self.delegate2?.backgroundColor = .red // it's a UIView ex hypothesi

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

