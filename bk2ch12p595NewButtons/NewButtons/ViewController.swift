
import UIKit

extension UIControl {
    func addAction(for event: UIControl.Event,
                   handler: @escaping UIActionHandler) {
        self.addAction(UIAction(handler:handler), for:event)
    }
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}
extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}

class ViewController: UIViewController {
    
    var currentFavorite : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // let's make some buttons the new iOS 14 way
        
        var which : Int { 5 }
        switch which {
        case 1:
            // inherited from UIControl
            let b = UIButton(frame: CGRect(50,200,100,50))
            print(b.buttonType.rawValue)
            // that is a .custom button
        case 2:
            // inherited from UIControl
            let b = UIButton(frame: CGRect(50,200,100,50), primaryAction: UIAction(
                title: "Hello",
                image: UIImage(named: "trashlittle")!.withRenderingMode(.alwaysTemplate),
                handler: { action in
                    print("Hello")
                }
            ))
            print(b.buttonType.rawValue)
            // that is a .custom button
            // b.tintColor = .white
            self.view.addSubview(b)
            // self.view.backgroundColor = .systemFill // so we can see white text
        case 3:
            // UIButton-specific; type is optional, so I'll omit it
            let b = UIButton(primaryAction: UIAction(
                title: "Hello",
                image: UIImage(named: "trashlittle")!.withRenderingMode(.alwaysTemplate),
                handler: { action in
                    print("Hello")
                }
            ))
            b.frame = CGRect(50,200,100,50)
            print(b.buttonType.rawValue)
            // that is a .system button
            self.view.addSubview(b)
        case 4:
            // so what happens if we apply an action to an existing button?
            let b = UIButton(type: .system)
            b.setTitle("Howdy", for: .normal)
            b.sizeToFit()
            b.frame.origin = CGPoint(50,200)
            b.addAction(UIAction(title: "Test") { action in
                print("test")
            }, for: .touchUpInside)
            // nope, that didn't replace the title, hooray
            
            self.view.addSubview(b)
        case 5:
            // button menu
            let b = UIButton(type: .system)
            b.setTitle("Favorite Pep Boy:", for: .normal)
            b.sizeToFit()
            b.frame.origin = CGPoint(50,200)
            // "dynamic" menu, formed at the moment the user taps the button
            b.menu = UIMenu() // so that we have a menu to start with
            b.addAction(for: .menuActionTriggered) { action in
                guard let b = action.sender as? UIButton else { return }
                func boyAction(for name: String) -> UIAction {
                    let image : UIImage? =
                        name == self.currentFavorite ?
                        UIImage(systemName: "checkmark") :
                        nil
                    return UIAction(title: name, image: image) { [weak self] action in
                        self?.currentFavorite = action.title
                        b.setTitle("Favorite Pep Boy: \(name)", for: .normal)
                        b.sizeToFit()
                    }
                }
                b.menu = UIMenu(title: "", children: [
                    boyAction(for: "Manny"),
                    boyAction(for: "Moe"),
                    boyAction(for: "Jack")
                ])
            }
            b.showsMenuAsPrimaryAction = true
            self.view.addSubview(b)
        default: break
        }

    }

    
    deinit {
        print("farewell")
    }

}

