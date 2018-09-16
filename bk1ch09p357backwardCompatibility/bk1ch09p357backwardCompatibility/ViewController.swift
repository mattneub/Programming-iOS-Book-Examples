

import UIKit
import Photos
import ARKit

func print(_ item: @autoclosure () -> Any,
           separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        Swift.print(item(), separator:separator, terminator: terminator)
    #endif
}


class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        
        // UIApplication.shared.beginReceivingRemoteControlEvents()
        
        super.viewDidAppear(animated)
        
        print(self.view)
        NSLog("the view: %@", self.view)
        
        print("howdy")
        // space below is intentional
        
        
        
        
        
        
        let r = self.view.frame
        
        
        
        
        
        
        
        
        
        print(r)
        // new name of CGRectFromString
        NSLog("%@", NSCoder.string(for: r))

        
        // new availability checking in Xcode 7
        
        if #available(iOS 9.0, *) {
            let g = self.view.layoutGuides
            print(g)
        } else {
        }
        
        if #available(iOS 8.0, *) {
            let s = UIApplication.openSettingsURLString
            print(s)
        } else {
        }
        
        if #available(iOS 8.0, *) {
            let tc = UITraitCollection()
            _ = tc
        } else {
        }
        
        if #available(iOS 11.0, *) {
            let dei = NSDirectionalEdgeInsets()
            _ = dei
        } else {
            // Fallback on earlier versions
        }
        
//        if self.respondsToSelector("traitCollection") {
//            let tc = self.traitCollection
//            print(tc)
//        } else {
//            print("no trait collections")
//        }
        
//        if NSClassFromString("UITraitCollection") != nil {
//            print("trait collections ok")
//        } else {
//            print("no trait collections")
//        }
        
        
//        if UIApplication.safeToUseSettingsString() {
//            print("settings URL ok")
//        } else {
//            print("no settings URL")
//        }



    }


}

