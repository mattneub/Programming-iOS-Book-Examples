

import UIKit

class ViewController: UIViewController {
    @IBAction func doButton (sender:AnyObject) {
        let url = NSBundle.mainBundle().URLForResource("sunglasses", withExtension:"png")!
        let things = ["This is a cool picture", url]
        // let avc = UIActivityViewController(activityItems:things, applicationActivities:nil)
        let avc = UIActivityViewController(activityItems:things, applicationActivities:[MyCoolActivity(), MyElaborateActivity()])
        // new in iOS 8, completionHander replaced by completionWithItemsHandlers
        // the reason is that an extension, using this same API, can return values
        avc.completionWithItemsHandler = {
            (s: String?, ok: Bool, items: [AnyObject]?, err:NSError?) -> Void in
            print("completed \(s) \(ok) \(items) \(err)")
        }
        avc.excludedActivityTypes = [
            UIActivityTypePostToFacebook,
            UIActivityTypePostToTwitter,
            UIActivityTypePostToWeibo,
            UIActivityTypeMessage,
            UIActivityTypeMail,
            UIActivityTypePrint,
            UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo,
            UIActivityTypeAirDrop,
            UIActivityTypeOpenInIBooks,
        ]
        // avc.excludedActivityTypes = nil
        self.presentViewController(avc, animated:true, completion:nil)
        // on iPad this will be an action sheet and will need a source view or bar button item
        if let pop = avc.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
    }
}

// forget it, I can't figure this out
/*

extension ViewController : UIActivityItemSource {
    func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        print("here")
        return "This is cool"
    }
    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        return NSObject.init()
    }
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        return nil
    }
}

*/
