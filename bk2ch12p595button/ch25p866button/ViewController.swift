
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button : UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let im = UIImage(named:"coin")!
        let sz = im.size
        let im2 = im.resizableImage(withCapInsets:UIEdgeInsetsMake(
            sz.height/2, sz.width/2, sz.height/2, sz.width/2),
            resizingMode: .stretch)
        self.button.setBackgroundImage(im2, for:.normal)
        self.button.backgroundColor = .clear
        self.button.setImage(im2, for:.normal)
        
        let mas = NSMutableAttributedString(string: "Pay Tribute", attributes: [
            .font: UIFont(name:"GillSans-Bold", size:16)!,
            .foregroundColor: UIColor.purple,
            // in iOS 8.3 can comment out next line; bug is fixed
            // .underlineStyle: NSUnderlineStyle.StyleNone.rawValue
            ])
        mas.addAttributes([
            .strokeColor: UIColor.red,
            .strokeWidth: -2,
            .underlineStyle: NSUnderlineStyle.styleSingle.rawValue
            ], range: NSMakeRange(4, mas.length-4))
        self.button.setAttributedTitle(mas, for:.normal)
        
        let mas2 = mas.mutableCopy() as! NSMutableAttributedString
        mas2.addAttributes([
            .foregroundColor: UIColor.white
            ], range: NSMakeRange(0, mas2.length))
        self.button.setAttributedTitle(mas2, for: .highlighted)
        
        self.button.adjustsImageWhenHighlighted = true
        
        self.button2.titleLabel!.numberOfLines = 2
        self.button2.titleLabel!.textAlignment = .center
        self.button2.setTitle("Button with a title that wraps", for:.normal)
    }


}
