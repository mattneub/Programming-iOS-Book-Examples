

import UIKit
import NotificationCenter

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

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


// NB The widget is automatically used as a home screen shortcut!
// Since our widget is interactive, no need for anything else: it just works!

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var iv: UIImageView!
    let compactSize = CGSize(320,110)
    let expandedSize = CGSize(320,150)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = self.compactSize
        // uncomment next line to engage size-change mechanism
        // self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        self.iv.image = UIImage(named:"cup.jpg")
    }
        
    @IBAction func doButton(_ sender: Any) {
        // NSLog("doButton")
        let v = sender as! UIView
        var comp = URLComponents()
        comp.scheme = "coffeetime"
        comp.host = String(v.tag) // tag is number of minutes
        if let url = comp.url {
            // NSLog("%@", "\(url)")
            self.extensionContext?.open(url)
        }
    }
    
//    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(0,16,0,16)
//    }
    
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        NSLog("performUpdate")
        // Perform any setup necessary in order to update the view.

        // If an error is encoutered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        print(activeDisplayMode.rawValue)
        print(maxSize)
        // maxSize alternates between (304.0, 110.0) and (304.0, 440.0)
        switch activeDisplayMode {
        case .compact:
            self.preferredContentSize = self.compactSize
            delay(1) {
                print(self.view.bounds.height)
            }
        case .expanded:
            self.preferredContentSize = self.expandedSize
            delay(1) {
                print(self.view.bounds.height)
            }
        }
    }
    
}
