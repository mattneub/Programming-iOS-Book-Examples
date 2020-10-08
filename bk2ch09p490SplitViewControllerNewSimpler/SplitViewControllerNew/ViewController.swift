

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class ViewController: UIViewController {
    
    var chosenBoy : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let split = UISplitViewController(style: .doubleColumn)
        self.addChild(split)
        self.view.addSubview(split.view)
        split.view.frame = self.view.bounds
        split.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        split.didMove(toParent: self)
        
        let pepList = PepListViewController(isCompact:false)
        split.setViewController(pepList, for: .primary)
        
        let pep = OnePepBoyViewController()
        let pepNav = UINavigationController(rootViewController: pep)
        split.setViewController(pepNav, for: .secondary)
                
        let pepListCompact = PepListViewController(isCompact:true)
        let nav = UINavigationController(rootViewController: pepListCompact)
        split.setViewController(nav, for: .compact)
        
        split.delegate = self
        
    }
    var initial = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.initial {
            if self.traitCollection.userInterfaceIdiom == .pad {
                if self.view.bounds.width < self.view.bounds.height {
                    if let svc = self.children.first as? UISplitViewController {
                        svc.show(.primary)
                    }
                }
            }
        }
        self.initial = false
    }
}

extension ViewController : UISplitViewControllerDelegate {
    func swap(_ svc: UISplitViewController, collapsing: Bool) {
        if collapsing {
            if let boy = self.chosenBoy,
               let nav = svc.viewController(for: .compact) as? UINavigationController {
                let newPep = OnePepBoyViewController(pepBoy: boy)
                nav.popToRootViewController(animated: false)
                nav.pushViewController(newPep, animated: false)
            }
        } else {
            if let boy = self.chosenBoy,
               let list = svc.viewController(for: .primary) as? PepListViewController {
                let newPep = OnePepBoyViewController(pepBoy: boy)
                let nav = UINavigationController(rootViewController: newPep)
                list.showDetailViewController(nav, sender: self)
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
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        print("will change to")
        dump(displayMode)
    }
    
}

