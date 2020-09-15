

import UIKit

class ViewController: UIViewController {
    @IBAction func doButton (_ sender: Any) {
        let url = Bundle.main.url(forResource:"sunglasses", withExtension:"png")!
        let things : [Any] = ["This is a cool picture", url]
        // let avc = UIActivityViewController(activityItems:things, applicationActivities:nil)
        let avc = UIActivityViewController(activityItems:things, applicationActivities:[MyCoolActivity(), MyElaborateActivity()])
        // new in iOS 8, completionHander replaced by completionWithItemsHandlers
        // the reason is that an extension, using this same API, can return values
        // type is (UIActivityType?, Bool, [Any]?, Error?) -> Swift.Void
        avc.completionWithItemsHandler = {
            type, ok, items, err in
            print("completed \(type as Any) \(ok) \(items as Any) \(err as Any)")
        }
        avc.excludedActivityTypes = [
            .postToFacebook,
            .postToTwitter,
            .postToWeibo,
            .message,
            .mail,
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
            .markupAsPDF,
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

