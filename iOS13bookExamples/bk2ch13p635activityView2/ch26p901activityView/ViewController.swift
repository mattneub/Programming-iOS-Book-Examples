

import UIKit

class MyProvider : UIActivityItemProvider {
    override var item : Any {
        // time-consuming operation goes here
        return "Coolness"
    }
}

// test on device

class ViewController: UIViewController {
    @IBAction func doButton (_ sender: Any) {
        // supply `self` so we will be queried separately for the item
        // let avc = UIActivityViewController(activityItems:[self], applicationActivities:nil)
        // supply an item provider so it can supply the data lazily
        let avc = UIActivityViewController(activityItems:[MyProvider(placeholderItem: "")], applicationActivities:nil)

        avc.completionWithItemsHandler = {
            (type: UIActivity.ActivityType?, ok: Bool, items: [Any]?, err:Error?) -> Void in
            print("completed \(type as Any) \(ok) \(items as Any) \(err as Any)")
        }
        avc.excludedActivityTypes = [
            .postToFacebook,
            .postToTwitter,
            .postToWeibo,
            .message,
            // .mail
            .print,
            .copyToPasteboard,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .airDrop,
            .openInIBooks,
            UIActivity.ActivityType("com.apple.mobilenotes.SharingExtension") // nope, can't exclude a sharing extension
        ]
        // avc.excludedActivityTypes = nil
        self.present(avc, animated:true)
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
        _ activityViewController: UIActivityViewController)
        -> Any {
            return ""
    }
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?)
        -> Any? {
            print(activityType as Any)
            return "Coolness"
    }
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
            return "This is cool"
    }
}

