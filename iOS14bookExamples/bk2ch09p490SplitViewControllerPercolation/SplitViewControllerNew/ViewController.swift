

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

var supp : Bool { return false }

class ViewController: UIViewController {
    
    var chosenBoyPrimary : String?
    var chosenBoyCompact : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let split = MySplitViewController(style: supp ? .tripleColumn : .doubleColumn)
        self.addChild(split)
        self.view.addSubview(split.view)
        split.view.frame = self.view.bounds
        split.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        split.didMove(toParent: self)
        
        let pepList = PepListViewController()
        split.setViewController(pepList, for: .primary)
        
        let pep = Pep()
        let pepNav = MyNavigationController(rootViewController: pep)
        split.setViewController(pepNav, for: .secondary)
        
        // also prepare flow in case of compactness
        // here, _we_ have to supply the navigation controller
        let pepListCompact = PepListCompactViewController()
        let nav = MyNavigationController(rootViewController: pepListCompact)
        split.setViewController(nav, for: .compact)
        
        if supp { // just to see what one looks like
            let supp = UIViewController()
            supp.view.backgroundColor = .green
            split.setViewController(supp, for: .supplementary)
        }

        split.delegate = self
        
    }
}

extension ViewController : UISplitViewControllerDelegate {
    func swap(_ svc: UISplitViewController, collapsing: Bool) {
        if collapsing {
            if let boy = self.chosenBoyPrimary,
               let nav = svc.viewController(for: .compact) as? UINavigationController {
                let newPep = PepCompact(pepBoy: boy)
                nav.popToRootViewController(animated: false)
                nav.pushViewController(newPep, animated: false)
                self.chosenBoyCompact = boy
            }
        } else {
            if let boy = self.chosenBoyCompact,
               let list = svc.viewController(for: .primary) as? PepListViewController {
                let newPep = Pep(pepBoy: boy)
                let nav = MyNavigationController(rootViewController: newPep)
                list.showDetailViewController(nav, sender: self)
                self.chosenBoyPrimary = boy
            }
        }
    }
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        print("collapsing...")
        delay(0.1) {
            self.swap(svc, collapsing: true)
        }
        return proposedTopColumn
    }
    
    func splitViewController(_ svc: UISplitViewController, displayModeForExpandingToProposedDisplayMode proposedDisplayMode: UISplitViewController.DisplayMode) -> UISplitViewController.DisplayMode {
        print("expanding...")
        delay(0.1) {
            self.swap(svc, collapsing: false)
        }
        return proposedDisplayMode
    }
    
    // =======
    
    // but these are skipped in the new-style split view controller, all the better if you ask me
    /*
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        print(self, #function, "called")
        return false // meaning, not me, you do the normal thing
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, show vc: UIViewController, sender: Any?) -> Bool {
        print(self, #function, "called")
        return false // meaning, not me, you do the normal thing
    }
 */
}

extension UISplitViewController.Column {
    var which : [String] { ["primary", "supplementary", "secondary", "compact"]}
    var desc : String { which[self.rawValue] }
}

