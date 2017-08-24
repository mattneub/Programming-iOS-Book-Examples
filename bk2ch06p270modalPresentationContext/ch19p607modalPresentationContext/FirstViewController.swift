
import UIKit

class FirstViewController : UIViewController {
    
    
    let which = 3
    @IBAction func doPresent(_ sender: Any?) {
        switch which {
        case 1:
            let vc = ExtraViewController(nibName: nil, bundle: nil)
            vc.modalTransitionStyle = .flipHorizontal
            self.present(vc, animated: true)
            
        case 2:
            // in iOS 8/9, this works on iPhone as well as iPad!
            // presented vc appears over first vc *inside* tabbed interface
            let vc = ExtraViewController(nibName: nil, bundle: nil)
            vc.modalTransitionStyle = .flipHorizontal
            self.definesPresentationContext = true
            vc.modalPresentationStyle = .currentContext
            self.present(vc, animated: true)

        case 3:
            let vc = ExtraViewController(nibName: nil, bundle: nil)
            vc.modalTransitionStyle = .flipHorizontal
            self.definesPresentationContext = true
            // comment out next line to see the difference
            self.providesPresentationContextTransitionStyle = true
            self.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .currentContext
            
            vc.modalPresentationCapturesStatusBarAppearance = true
            
            self.present(vc, animated: true)

            
            
        default: break
        }
    }
    
    override func viewDidLoad() {
        self.tabBarController?.delegate = self
    }

}

/*
cases 2 and 3 also demonstrate a nasty bug
to see it:
start in First view, tap button to present
switch to Second view
switch back to First view, tap button to dismiss
black view, that's the bug
still there in iOS 9! (still there in iOS 11)
The following code stops the user from doing that, and so avoids the bug
*/

extension FirstViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return self.presentedViewController == nil
        return true
    }
}
