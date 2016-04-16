

import UIKit
import Photos

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // oddly, we now have to cast this one
        NSLog("%@", NSStringFromCGRect(self.view.frame) as NSString)

        
        // new availability checking in Xcode 7
        
        if #available(iOS 9.0, *) {
            let g = self.view.layoutGuides
            print(g)
        } else {
        }
        
        if #available(iOS 8.0, *) {
            let s = UIApplicationOpenSettingsURLString
            print(s)
        } else {
        }
        
        if #available(iOS 8.0, *) {
            let tc = UITraitCollection()
            _ = tc
        } else {
        }
        
        let v = UIDevice.current().systemVersion
        print(v)
        
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

