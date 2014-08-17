

import UIKit
import Photos

class DataViewController: UIViewController {
                            
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet var frameview : UIView!
    @IBOutlet var iv : UIImageView!
    var dataObject: AnyObject?
    var index : Int = -1

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let obj: AnyObject = dataObject {
            self.dataLabel!.text = obj.description
        } else {
            self.dataLabel!.text = ""
        }
        // okay, this is why we are here! fetch the image data!!!!!
        // we have to say quite specifically what "view" of image we want
        PHImageManager.defaultManager().requestImageForAsset(self.dataObject as PHAsset, targetSize: CGSizeMake(300,300), contentMode: .AspectFit, options: nil) {
            (im:UIImage!, info:[NSObject : AnyObject]!) -> Void in
            // this block can be called multiple times
            // and you can see why: initially we might get a degraded version of the image
            self.iv.image = im
        }
    }


}

