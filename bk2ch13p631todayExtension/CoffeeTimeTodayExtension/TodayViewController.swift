

import UIKit
import NotificationCenter

// NB The widget is automatically used as a home screen shortcut!
// Since our widget is interactive, no need for anything else: it just works!

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var iv: UIImageView!
    
    required init?(coder: NSCoder) {
        NSLog("init")
        super.init(coder:coder)
    }
    
    override func awakeFromNib() {
        NSLog("awake")
        super.awakeFromNib()
        // self.preferredContentSize = CGSize(320,113)
        // let v = UIVisualEffectView(effect: UIVibrancyEffect.notificationCenterVibrancyEffect())

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.preferredContentSize = CGSize(320,113)
        self.iv.image = UIImage(named:"cup.jpg")
    }
        
    @IBAction func doButton(_ sender: Any) {
        NSLog("doButton")
        let v = sender as! UIView
        var comp = URLComponents()
        comp.scheme = "coffeetime"
        comp.host = String(v.tag) // tag is number of minutes
        if let url = comp.url(relativeTo:nil) {
            NSLog("%@", "\(url)")
            self.extensionContext?.open(url)
        }
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0,16,0,16)
    }
    
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        NSLog("performUpdate")
        // Perform any setup necessary in order to update the view.

        // If an error is encoutered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }
    
}
