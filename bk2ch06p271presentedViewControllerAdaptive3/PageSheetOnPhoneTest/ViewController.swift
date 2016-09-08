

import UIKit

class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    var adaptiveType : UIModalPresentationStyle = .none
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print(controller.presentationStyle.rawValue)
        print(self.adaptiveType.rawValue)
        return self.adaptiveType
    }
    
    func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        print(style.rawValue)
    }
    
    // this seems incoherent to me
    // you can adapt PageSheet to None and get a page sheet...
    // but if you adapt PageSheet to PageSheet you get FullScreen?????
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let d = segue.destination
        if segue.identifier == "test1" {
            self.adaptiveType = .none
            d.presentationController!.delegate = self
        }
        if segue.identifier == "test2" {
            self.adaptiveType = .pageSheet
            d.presentationController!.delegate = self
        }
    }
    

    @IBAction func doDismiss(_ sender: Any) {
        self.dismiss(animated:true)
    }
}

