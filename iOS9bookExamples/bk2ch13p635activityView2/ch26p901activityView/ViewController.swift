

import UIKit

class MyProvider : UIActivityItemProvider {
    override func item() -> AnyObject {
        // time-consuming operation goes here
        return "Coolness"
    }
}

class ViewController: UIViewController {
    @IBAction func doButton (sender:AnyObject) {
        // supply `self` so we will be queried separately for the item
        // let avc = UIActivityViewController(activityItems:[self], applicationActivities:nil)
        // supply an item provider so it can supply the data lazily
        let avc = UIActivityViewController(activityItems:[MyProvider(placeholderItem: "")], applicationActivities:nil)

        avc.completionWithItemsHandler = {
            (s: String?, ok: Bool, items: [AnyObject]?, err:NSError?) -> Void in
            print("completed \(s) \(ok) \(items) \(err)")
        }
        avc.excludedActivityTypes = [
            UIActivityTypePostToFacebook,
            UIActivityTypePostToTwitter,
            UIActivityTypePostToWeibo,
            UIActivityTypeMessage,
            // UIActivityTypeMail,
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
            "com.apple.mobilenotes.SharingExtension" // nope, can't exclude a sharing extension
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

extension ViewController : UIActivityItemSource {
    func activityViewControllerPlaceholderItem(
        activityViewController: UIActivityViewController)
        -> AnyObject {
            return ""
    }
    func activityViewController(
        activityViewController: UIActivityViewController,
        itemForActivityType activityType: String)
        -> AnyObject? {
            print(activityType)
            return "Coolness"
    }
    func activityViewController(
        activityViewController: UIActivityViewController,
        subjectForActivityType activityType: String?) -> String {
            return "This is cool"
    }
}

