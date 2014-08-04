
import UIKit

func imageFromContextOfSize(size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

class ViewController: UIViewController {
    
    @IBOutlet var stepper : UIStepper!
    @IBOutlet var prog : UIProgressView!
    
    @IBAction func doStep(sender:AnyObject!) {
        let step = sender as UIStepper
        self.prog.progress = Float(step.value / (step.maximumValue - step.minimumValue))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stepper.tintColor = UIColor.yellowColor()
        
        let imdis = UIImage(named: "pic2.png")
            .resizableImageWithCapInsets(
                UIEdgeInsetsMake(1, 1, 1, 1), resizingMode:.Stretch)
        self.stepper.setBackgroundImage(imdis, forState:.Disabled)
        
        let imnorm = UIImage(named: "pic1.png")
            .resizableImageWithCapInsets(
                UIEdgeInsetsMake(1, 1, 1, 1), resizingMode:.Stretch)
        self.stepper.setBackgroundImage(imnorm, forState:.Normal)
        
        let tint = imageFromContextOfSize(CGSizeMake(3,3)) {
            self.stepper.tintColor.setFill()
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,3,3))
        }.resizableImageWithCapInsets(
            UIEdgeInsetsMake(1, 1, 1, 1), resizingMode:.Stretch)
        self.stepper.setDividerImage(tint, forLeftSegmentState:.Normal, rightSegmentState:.Normal)
        self.stepper.setDividerImage(tint, forLeftSegmentState:.Highlighted, rightSegmentState:.Normal)
        self.stepper.setDividerImage(tint, forLeftSegmentState:.Normal, rightSegmentState:.Highlighted)

        // image (treated as template by default)
        
        let imleft = imageFromContextOfSize(CGSizeMake(45,29)) {
            NSAttributedString(string:"\u{21DA}", attributes:[
                NSFontAttributeName: UIFont(name:"GillSans-Bold", size:30),
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSParagraphStyleAttributeName: {
                    let para = NSMutableParagraphStyle()
                    para.alignment = .Center
                    return para
                    }()
                ]).drawInRect(CGRectMake(0,-5,45,29))
        }.imageWithRenderingMode(.AlwaysOriginal)
        self.stepper.setDecrementImage(imleft, forState:.Normal)
        
        let imleftblack = imageFromContextOfSize(CGSizeMake(45,29)) {
            NSAttributedString(string:"\u{21DA}", attributes:[
                NSFontAttributeName: UIFont(name:"GillSans-Bold", size:30),
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSParagraphStyleAttributeName: {
                    let para = NSMutableParagraphStyle()
                    para.alignment = .Center
                    return para
                    }()
                ]).drawInRect(CGRectMake(0,-5,45,29))
            }.imageWithRenderingMode(.AlwaysOriginal)
        self.stepper.setDecrementImage(imleftblack, forState:.Disabled)

        let imlefttint = imageFromContextOfSize(CGSizeMake(45,29)) {
            NSAttributedString(string:"\u{21DA}", attributes:[
                NSFontAttributeName: UIFont(name:"GillSans-Bold", size:30),
                NSForegroundColorAttributeName: self.stepper.tintColor,
                NSParagraphStyleAttributeName: {
                    let para = NSMutableParagraphStyle()
                    para.alignment = .Center
                    return para
                    }()
                ]).drawInRect(CGRectMake(0,-5,45,29))
            }.imageWithRenderingMode(.AlwaysOriginal)
        self.stepper.setDecrementImage(imlefttint, forState:.Highlighted)

        let imright = imageFromContextOfSize(CGSizeMake(45,29)) {
            NSAttributedString(string:"\u{21DB}", attributes:[
                NSFontAttributeName: UIFont(name:"GillSans-Bold", size:30),
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSParagraphStyleAttributeName: {
                    let para = NSMutableParagraphStyle()
                    para.alignment = .Center
                    return para
                    }()
                ]).drawInRect(CGRectMake(0,-5,45,29))
            }.imageWithRenderingMode(.AlwaysOriginal)
        self.stepper.setIncrementImage(imright, forState:.Normal)
        
        let imrightblack = imageFromContextOfSize(CGSizeMake(45,29)) {
            NSAttributedString(string:"\u{21DB}", attributes:[
                NSFontAttributeName: UIFont(name:"GillSans-Bold", size:30),
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSParagraphStyleAttributeName: {
                    let para = NSMutableParagraphStyle()
                    para.alignment = .Center
                    return para
                    }()
                ]).drawInRect(CGRectMake(0,-5,45,29))
            }.imageWithRenderingMode(.AlwaysOriginal)
        self.stepper.setIncrementImage(imrightblack, forState:.Disabled)
        
        let imrighttint = imageFromContextOfSize(CGSizeMake(45,29)) {
            NSAttributedString(string:"\u{21DB}", attributes:[
                NSFontAttributeName: UIFont(name:"GillSans-Bold", size:30),
                NSForegroundColorAttributeName: self.stepper.tintColor,
                NSParagraphStyleAttributeName: {
                    let para = NSMutableParagraphStyle()
                    para.alignment = .Center
                    return para
                    }()
                ]).drawInRect(CGRectMake(0,-5,45,29))
            }.imageWithRenderingMode(.AlwaysOriginal)
        self.stepper.setIncrementImage(imrighttint, forState:.Highlighted)

        return; // interesting effect: remove overlay entirely if disabled
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,29), false, 0)
        let emptyim = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        self.stepper.setDecrementImage(emptyim, forState:.Disabled)
        self.stepper.setIncrementImage(emptyim, forState:.Disabled)
        
    }


}
