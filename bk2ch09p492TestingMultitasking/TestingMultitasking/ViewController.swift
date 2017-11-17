
import UIKit
import os.log

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("%{public}@", log: log, #function)
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        os_log("%{public}@", log: log, #function)
        if self.presentingViewController != nil {
            self.view.backgroundColor = .yellow
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        os_log("%{public}@", log: log, #function)
    }
    
    @IBAction func doButton(_ sender: Any) {
        if self.presentingViewController != nil {
            self.dismiss(animated:true)
        } else {
            print("window frame is \(self.view.window!.frame)")
            print("window bounds are \(self.view.window!.bounds)")
            print("screen bounds are \(UIScreen.main.bounds)")
            let v = sender as! UIView
            let r = self.view.window!.convert(v.bounds, from: v)
            print("button in window is \(r)")
            let r2 = v.convert(v.bounds, to: UIScreen.main.coordinateSpace)
            print("button in screen is \(r2)")
        }
    }
    
    
    @IBAction func doButton2(_ sender: Any) {
        if self.presentingViewController != nil {
            return
        }
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC") {
            var which : Int { return 1 }
            switch which {
            case 1:
                vc.modalPresentationStyle = .formSheet
            case 2:
                vc.modalPresentationStyle = .popover
                if let pop = vc.popoverPresentationController {
                    let v = sender as! UIView
                    pop.sourceView = v
                    pop.sourceRect = v.bounds
                }
            default: break
            }
            vc.presentationController!.delegate = self
            self.present(vc, animated:true)

        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        os_log("SIZE %{public}@ %d", log: log, #function, UIApplication.shared.applicationState.rawValue)
        let larger = max(size.width, size.height)
        let smaller = min(size.width, size.height)
        print(#function, size, larger/smaller, terminator:"\n\n")
        super.viewWillTransition(to: size, with: coordinator)
        delay(1) {
            let ok = self.traitCollection.horizontalSizeClass == .compact
            print("compact?", ok, terminator:"\n\n")
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        os_log("TRAIT %{public}@ %d", log: log, #function, UIApplication.shared.applicationState.rawValue)
        print(#function, newCollection, terminator:"\n\n")
        super.willTransition(to: newCollection, with: coordinator)
        delay(1) {
            let ok = self.traitCollection.horizontalSizeClass == .compact
            print("compact?", ok, terminator:"\n\n")
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print(#function, self.traitCollection, terminator:"\n\n")
        super.traitCollectionDidChange(previousTraitCollection)
    }

}

extension ViewController : UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("adapt!")
        if traitCollection.horizontalSizeClass == .compact {
            return .fullScreen
        }
        return .none
    }

}

