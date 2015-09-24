

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var iv: UIImageView!
    
    required init?(coder: NSCoder) {
        NSLog("init")
        super.init(coder:coder)
    }
    
    override func awakeFromNib() {
        NSLog("awake")
        super.awakeFromNib()
        // self.preferredContentSize = CGSizeMake(320,113)
        // let v = UIVisualEffectView(effect: UIVibrancyEffect.notificationCenterVibrancyEffect())

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.preferredContentSize = CGSizeMake(320,113)
        self.iv.image = UIImage(named:"cup.png")?.imageWithRenderingMode(.AlwaysTemplate)
    }
        
    @IBAction func doButton(sender: AnyObject) {
        NSLog("doButton")
        let v = sender as! UIView
        let t = v.tag // tag is number of minutes
        if let url = NSURL(string:"coffeetime://\(t)") {
            NSLog("%@", "\(url)")
            self.extensionContext?.openURL(url, completionHandler: nil)
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0,16,0,16)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        NSLog("performUpdate")
        // Perform any setup necessary in order to update the view.

        // If an error is encoutered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
