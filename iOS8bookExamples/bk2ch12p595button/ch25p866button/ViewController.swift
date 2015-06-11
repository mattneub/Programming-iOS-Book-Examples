
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let im = UIImage(named:"coin2.png")!
        let sz = im.size
        let im2 = im.resizableImageWithCapInsets(UIEdgeInsetsMake(
            sz.height/2, sz.width/2, sz.height/2, sz.width/2),
            resizingMode: .Stretch)
        self.button.setBackgroundImage(im2, forState: .Normal)
        self.button.backgroundColor = UIColor.clearColor()
        self.button.setImage(im2, forState: .Normal)
        
        let mas = NSMutableAttributedString(string: "Pay Tribute", attributes: [
            NSFontAttributeName: UIFont(name:"GillSans-Bold", size:16)!,
            NSForegroundColorAttributeName: UIColor.purpleColor(),
            // in iOS 8.3 can comment out next line; bug is fixed
            // NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue
            ])
        mas.addAttributes([
            NSStrokeColorAttributeName: UIColor.redColor(),
            NSStrokeWidthAttributeName: -2,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
            ], range: NSMakeRange(4, mas.length-4))
        self.button.setAttributedTitle(mas, forState: .Normal)
        
        let mas2 = mas.mutableCopy() as! NSMutableAttributedString
        mas2.addAttributes([
            NSForegroundColorAttributeName: UIColor.whiteColor()
            ], range: NSMakeRange(0, mas2.length))
        self.button.setAttributedTitle(mas2, forState: .Highlighted)
        
        self.button.adjustsImageWhenHighlighted = true
    }


}
