
import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("%@", __FUNCTION__)
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        NSLog("%@", __FUNCTION__)
        if self.presentingViewController != nil {
            self.view.backgroundColor = UIColor.yellowColor()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("%@", __FUNCTION__)
    }
    
    @IBAction func doButton(sender: AnyObject) {
        if self.presentingViewController != nil {
            self.dismissViewControllerAnimated(true, completion:nil)
        } else {
            print("window bounds are \(self.view.window!.bounds)")
            print("screen bounds are \(UIScreen.mainScreen().bounds)")
            let v = sender as! UIView
            let r = self.view.window?.convertRect(v.bounds, fromView: v)
            print("button in window is \(r)")
            let r2 = v.convertRect(v.bounds, toCoordinateSpace: UIScreen.mainScreen().coordinateSpace)
            print("button in screen is \(r2)")
        }
    }
    
    let which = 2
    
    @IBAction func doButton2(sender: AnyObject) {
        if self.presentingViewController != nil {
            return
        }
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("VC") {
            switch which {
            case 1:
                vc.modalPresentationStyle = .FormSheet
            case 2:
                vc.modalPresentationStyle = .Popover
                if let pop = vc.popoverPresentationController {
                    let v = sender as! UIView
                    pop.sourceView = v
                    pop.sourceRect = v.bounds
                }
            default: break
            }
            vc.presentationController!.delegate = self
            self.presentViewController(vc, animated:true, completion:nil)

        }
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print(__FUNCTION__, size, terminator:"\n\n")
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print(__FUNCTION__, newCollection, terminator:"\n\n")
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        print(__FUNCTION__, self.traitCollection, terminator:"\n\n")
        super.traitCollectionDidChange(previousTraitCollection)
    }

}

extension ViewController : UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("adapt!")
        if traitCollection.horizontalSizeClass == .Compact {
            return .FullScreen
        }
        return .None
    }

}

