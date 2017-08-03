

import UIKit

class MyClass : NSObject {
}
class MyClass2 : NSObject {
    @objc func woohoo() {
        print("woohoo")
    }
}
@objc protocol Dummy {
    func woohoo()
}

protocol ButtonLike {
    func behaveInButtonLikeWay()
}
extension ButtonLike {
    func behaveInButtonLikeWay() {
        // ...
    }
}
extension UIButton : ButtonLike {}
extension UIBarButtonItem : ButtonLike {}


class NewGameController : UIViewController {
    weak var tableView : UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.dataSource = self
        // ...
    }
}
extension NewGameController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ...
        let cell = UITableViewCell() // just so the example will compile
        return cell
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let mc = MyClass()
        if mc.responds(to: #selector(Dummy.woohoo)) {
            print("here1")
            (mc as AnyObject).woohoo()
        }
        let mc2 = MyClass2()
        if mc2.responds(to: #selector(Dummy.woohoo)) {
            print("here2")
            (mc2 as AnyObject).woohoo()
        }
        (mc as AnyObject).woohoo?()
        (mc2 as AnyObject).woohoo?()



    }


}

