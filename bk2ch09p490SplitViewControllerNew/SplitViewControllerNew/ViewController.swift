

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
        
        let split = UISplitViewController(style: supp ? .tripleColumn : .doubleColumn)
        self.addChild(split)
        self.view.addSubview(split.view)
        split.view.frame = self.view.bounds
        split.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        split.didMove(toParent: self)
        
        let pepList = PepListViewController()
        split.setViewController(pepList, for: .primary)
        
        let pep = Pep()
        let pepNav = UINavigationController(rootViewController: pep)
        split.setViewController(pepNav, for: .secondary)
        
        // also prepare flow in case of compactness
        // here, _we_ have to supply the navigation controller
        let pepListCompact = PepListCompactViewController()
        let nav = UINavigationController(rootViewController: pepListCompact)
        split.setViewController(nav, for: .compact)
        
        if supp { // just to see what one looks like
            let supp = UIViewController()
            supp.view.backgroundColor = .green
            split.setViewController(supp, for: .supplementary)
        }

        split.delegate = self
                
        delay(2) {
            print(split.viewControllers) // NB, no longer encompasses all vcs
            print(split.children) // ooo, on compact this is all three
            print(pepList.splitViewController as Any)
            print(pepListCompact.splitViewController as Any)
            print(pep.splitViewController as Any)
        }
    }
}

extension ViewController : UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, willShow column: UISplitViewController.Column) {
        print(column.desc, "will show")
    }
    func splitViewController(_ svc: UISplitViewController, willHide column: UISplitViewController.Column) {
        print(column.desc, "will hide")
    }
    func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
        print("did collapse")
    }
    func splitViewControllerDidExpand(_ svc: UISplitViewController) {
        print("did expand")
    }
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        print("collapsing...")
        if let boy = self.chosenBoyPrimary,
           let nav = svc.viewController(for: .compact) as? UINavigationController {
                let newPep = PepCompact(pepBoy: boy)
                nav.popToRootViewController(animated: false)
                nav.pushViewController(newPep, animated: false)
        }
        return proposedTopColumn
    }
    
    func splitViewController(_ svc: UISplitViewController, displayModeForExpandingToProposedDisplayMode proposedDisplayMode: UISplitViewController.DisplayMode) -> UISplitViewController.DisplayMode {
        print("expanding...")
        if let boy = self.chosenBoyCompact,
           let list = svc.viewController(for: .primary) as? PepListViewController {
                delay(0.1) {
                    let newPep = Pep(pepBoy: boy)
                    let nav = UINavigationController(rootViewController: newPep)
                    list.showDetailViewController(nav, sender: self)
                }
        }
        return proposedDisplayMode
    }
}

extension UISplitViewController.Column {
    var which : [String] { ["primary", "supplementary", "secondary", "compact"]}
    var desc : String { which[self.rawValue] }
}

// iphone launch: compact will show, did collapse

// clean launch on ipad portrait is wrong: we see empty with Back button, secondary will show, no primary

// suppose Moe is showing in split, we unsplit: still see moe, that's good, but moe is not selected in primary

// suppose Jack is showing in full, we split to become compact: we collapse to Moe or maybe it's to whatever was showing last time we were compact
