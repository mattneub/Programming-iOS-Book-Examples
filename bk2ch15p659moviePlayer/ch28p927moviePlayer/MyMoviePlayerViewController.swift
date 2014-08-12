

import UIKit
import MediaPlayer

class MyMoviePlayerViewController : MPMoviePlayerViewController {
    override func supportedInterfaceOrientations() -> Int {
        println("he asked me, he asked me") // how to prevent portrait (or whatever)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
        return Int(UIInterfaceOrientationMask.Landscape.toRaw())
    }
}

class MyVideoEditorController : UIVideoEditorController {
    override func supportedInterfaceOrientations() -> Int {
        println("he asked me, he asked me") // how to prevent portrait (or whatever)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
        return Int(UIInterfaceOrientationMask.Landscape.toRaw())
    }
}
