
import UIKit
import UserNotifications
import UserNotificationsUI

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



// Info.plist must contain these keys:

// UNNotificationExtensionCategory
// UNNotificationExtensionInitialContentSizeRatio

// optional: UNNotificationExtensionDefaultContentHidden
// optional: UNNotificationExtensionOverridesDefaultTitle

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(320, 80)
    }
    
    func didReceive(_ notification: UNNotification) {
        let req = notification.request
        let content = req.content
        let atts = content.attachments
        if let att = atts.first, att.identifier == "cup" {
            if att.url.startAccessingSecurityScopedResource() { // system has copy!
                if let data = try? Data(contentsOf: att.url) {
                    self.imageView.image = UIImage(data: data)
                }
                att.url.stopAccessingSecurityScopedResource()
            }
        }
        self.title = "Time for a cup of coffee!" // works if overrides default title is YES
        self.view.setNeedsLayout() // seems to help things along
        
        // new iOS 12 feature: live content button management
        // create actions
        // options are:
        // foreground (if not, background)
        // destructive (if not, normal appearance)
        // authenticationRequired (if so, cannot just do directly from lock screen)
        let action1 = UNNotificationAction(identifier: "snooze", title: "Snooze")
        let action2 = UNNotificationAction(identifier: "reconfigure",
                                           title: "Reconfigure", options: [.foreground])
        let action3 = UNTextInputNotificationAction(identifier: "message", title: "Message", options: [], textInputButtonTitle: "Message", textInputPlaceholder: "message")
        self.extensionContext?.notificationActions = [action1, action2]
        _ = action3
        
        // interactive view
        let t = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(t)
    }
    
    @objc func tap (_ : UIGestureRecognizer) {
        //self.extensionContext?.performNotificationDefaultAction()
        print("tap!")
        self.extensionContext?.dismissNotificationContentExtension()
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        print("ha ha, I received this")
        completion(.dismissAndForwardAction)
    }
}
