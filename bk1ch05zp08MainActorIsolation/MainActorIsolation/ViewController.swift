

import UIKit

actor MyActor {
    func actorMethod() async {
        print("actor method: main thread?", Thread.isMainThread)
        
        // an actor can't do illegal main actor stuff directly
        // this line doesn't compile
        // UIImageView().image = UIImage()
        
        // But this is legal according to the compiler,
        // even though it crashes because view controller init is not on main thread
        // I regard that as a bug
        let vc = ViewController()
        // await vc.viewControllerMethod()
    }
}

// @MainActor
class ViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            // await MyActor().actorMethod()
        }
        Task.detached {
            // again, the compiler catches this one
            // UIImageView().image = UIImage()
            
            // but it permits this one through
            // and that's fine, `viewControllerMethod` is called on main thread
            // but only if the class is explicitly marked as MainActor!
            // if you delete that marking, we crash on a background thread
            // so it looks like @MainActor class status is _not_ inherited
            // at least not by non-override methods
            // but the proposal says it should be, so I regard that as a bug
            // still the same in RC
            await self.viewControllerMethod()
        }
    }
    
    func viewControllerMethod() {
        print("view controller method: main thread?", Thread.isMainThread)
        UIImageView().image = UIImage()
    }
    
}

