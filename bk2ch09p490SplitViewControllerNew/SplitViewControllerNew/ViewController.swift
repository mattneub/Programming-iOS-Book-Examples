

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

var supp : Bool { return false }

class ViewController: UIViewController {
    
    var chosenBoy : String?
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
        
        print(split.presentsWithGesture)
        split.presentsWithGesture = true // also affects button presence! default is true
        print(split.showsSecondaryOnlyButton)
        split.showsSecondaryOnlyButton = true // only in three-columns; default is false
        
        // experiment to show that you must set the maximum for the others to take effect
//        split.preferredPrimaryColumnWidthFraction = 0.5
//        split.preferredPrimaryColumnWidth = 800
//        print(split.maximumPrimaryColumnWidth)
//        split.maximumPrimaryColumnWidth = 1000
                
        delay(2) {
            print(split.viewControllers) // NB, no longer encompasses all vcs
            print(split.children) // ooo, on compact this is all three
            print(pepList.splitViewController as Any)
            print(pepListCompact.splitViewController as Any)
            print(pep.splitViewController as Any)
        }
    }
    var initial = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.initial {
            if self.traitCollection.userInterfaceIdiom == .pad {
                if self.view.bounds.width < self.view.bounds.height {
                    let svc = self.children[0] as! UISplitViewController
                    svc.show(.primary)
                }
            }
            var playTricks: Bool { false }
            if playTricks {
                self.playThoseTricks()
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
                let newPep = PepCompact(pepBoy: boy)
                nav.popToRootViewController(animated: false)
                nav.pushViewController(newPep, animated: false)
            }
        } else {
            if let boy = self.chosenBoy,
               let list = svc.viewController(for: .primary) as? PepListViewController {
                let newPep = Pep(pepBoy: boy)
                let nav = UINavigationController(rootViewController: newPep)
                list.showDetailViewController(nav, sender: self)
            }
        }
    }
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
    
    func splitViewControllerInteractivePresentationGestureWillBegin(_ svc: UISplitViewController) {
        print("gesture beginning")
    }
    func splitViewControllerInteractivePresentationGestureDidEnd(_ svc: UISplitViewController) {
        print("gesture ended")
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

extension ViewController {
    func playThoseTricks() {
        print("tricks")
        let svc = self.children[0] as! UISplitViewController
        svc.preferredSplitBehavior = .tile
        svc.preferredDisplayMode = .oneBesideSecondary
        svc.maximumPrimaryColumnWidth = 200
        svc.preferredPrimaryColumnWidthFraction = 0.5
        let reg = UITraitCollection(horizontalSizeClass: .regular)
        let traits = UITraitCollection(traitsFrom: [reg])
        self.setOverrideTraitCollection(traits, forChild: svc)
    }
}
