
import UIKit

class ViewController: UIViewController {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(self.view.bounds.size)
        print(self.navigationController?.view.bounds.size as Any)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private var hide = false
    
    override var prefersStatusBarHidden : Bool {
        // return false
        return self.hide
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return super.preferredStatusBarStyle
        if let sc = self.view.window?.windowScene {
            if let sbman = sc.statusBarManager {
                if sbman.statusBarStyle == .darkContent {
                    return .lightContent
                } else {
                    return .darkContent
                }
            }
        }
        return super.preferredStatusBarStyle
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
        return .slide
    }

    @IBAction func doButton(_ sender: Any) {
        self.hide.toggle()
//        self.setNeedsStatusBarAppearanceUpdate()
//        return;
        UIView.animate(withDuration:1, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
            // self.view.layoutIfNeeded()
        }) { _ in
            // new in iOS 13
            if let sbman = self.view.window?.windowScene?.statusBarManager {
                print(sbman.statusBarFrame)
                // 0 default and 1 light, 3 is the new forced dark content
                // ok but it looks like we will never _report_ as 0!
                // we report as 1 or 3, kind of weird though I see the point
                print(sbman.statusBarStyle.rawValue)
                print(sbman.isStatusBarHidden)
            }
        }
    }
}

