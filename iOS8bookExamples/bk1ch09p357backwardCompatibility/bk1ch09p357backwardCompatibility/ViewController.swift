

import UIKit
import Photos

class ViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let v = UIDevice.currentDevice().systemVersion
        println(v)
        
        if self.respondsToSelector("traitCollection") {
            let tc = self.traitCollection
            println(tc)
        } else {
            println("no trait collections")
        }
        
        if NSClassFromString("UITraitCollection") != nil {
            println("trait collections ok")
        } else {
            println("no trait collections")
        }
        
        if UIApplication.safeToUseSettingsString() {
            println("settings URL ok")
        } else {
            println("no settings URL")
        }



    }


}

