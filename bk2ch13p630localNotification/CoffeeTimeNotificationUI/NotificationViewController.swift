
import UIKit
import UserNotifications
import UserNotificationsUI

// Info.plist must contain these keys:

// UNNotificationExtensionCategory
// UNNotificationExtensionInitialContentSizeRatio

// optional: UNNotificationExtensionDefaultContentHidden

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 320, height: 80)
        }
        set {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc(didReceiveNotification:)
    func didReceive(_ notification: UNNotification) {
        let req = notification.request
        let content = req.content
        let atts = content.attachments
        if let att = atts.first {
            if att.url.startAccessingSecurityScopedResource() { // system has copy!
                self.imageView.image = UIImage(contentsOfFile:att.url.path)
                att.url.stopAccessingSecurityScopedResource()
            }
        }
    }

}
