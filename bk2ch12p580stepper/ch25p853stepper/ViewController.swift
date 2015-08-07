
import UIKit

func imageOfSize(size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}


class ViewController: UIViewController {
    
    @IBOutlet var stepper : UIStepper!
    @IBOutlet var prog : UIProgressView!
    
    @IBAction func doStep(sender:AnyObject!) {
        let step = sender as! UIStepper
        self.prog.setProgress(Float(step.value / (step.maximumValue - step.minimumValue)), animated:true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stepper.tintColor = UIColor.yellowColor()
        
        let imdis = UIImage(named: "pic2.png")!
            .resizableImageWithCapInsets(
                UIEdgeInsetsMake(1, 1, 1, 1), resizingMode:.Stretch)
        self.stepper.setBackgroundImage(imdis, forState:.Disabled)
        
        let imnorm = UIImage(named: "pic1.png")!
            .resizableImageWithCapInsets(
                UIEdgeInsetsMake(1, 1, 1, 1), resizingMode:.Stretch)
        self.stepper.setBackgroundImage(imnorm, forState:.Normal)
        
        let tint = imageOfSize(CGSizeMake(3,3)) {
            self.stepper.tintColor.setFill()
            CGContextFillRect(UIGraphicsGetCurrentContext()!, CGRectMake(0,0,3,3))
        }.resizableImageWithCapInsets(
            UIEdgeInsetsMake(1, 1, 1, 1), resizingMode:.Stretch)
        self.stepper.setDividerImage(tint, forLeftSegmentState:.Normal, rightSegmentState:.Normal)
        self.stepper.setDividerImage(tint, forLeftSegmentState:.Highlighted, rightSegmentState:.Normal)
        self.stepper.setDividerImage(tint, forLeftSegmentState:.Normal, rightSegmentState:.Highlighted)

        // image (treated as template by default)
        
        let imleft = imageOfSize(CGSizeMake(45,29)) {
            NSAttributedString(string:"\u{21DA}", attributes:[
                NSFontAttributeName: UIFont(name:"GillSans-Bold", size:30)!,
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSParagraphStyleAttributeName: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .Center
                    }
                ]).drawInRect(CGRectMake(0,-5,45,29))
        }.imageWithRenderingMode(.AlwaysOriginal)
        self.stepper.setDecrementImage(imleft, forState:.Normal)
        
        let imleftblack = imageOfSize(CGSizeMake(45,29)) {
            NSAttributedString(string:"\u{21DA}", attributes:[
                NSFontAttributeName: UIFont(name:"GillSans-Bold", size:30)!,
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSParagraphStyleAttributeName: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .Center
                }
                ]).drawInRect(CGRectMake(0,-5,45,29))
            }.imageWithRenderingMode(.AlwaysOriginal)
        self.stepper.setDecrementImage(imleftblack, forState:.Disabled)

        let imlefttint = imageOfSize(CGSizeMake(45,29)) {
            NSAttributedString(string:"\u{21DA}", attributes:[
                NSFontAttributeName: UIFont(name:"GillSans-Bold", size:30)!,
                NSForegroundColorAttributeName: self.stepper.tintColor,
                NSParagraphStyleAttributeName: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .Center
                }
                ]).drawInRect(CGRectMake(0,-5,45,29))
            }.imageWithRenderingMode(.AlwaysOriginal)
        self.stepper.setDecrementImage(imlefttint, forState:.Highlighted)

        let imright = imageOfSize(CGSizeMake(45,29)) {
            NSAttributedString(string:"\u{21DB}", attributes:[
                NSFontAttributeName: UIFont(name:"GillSans-Bold", size:30)!,
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSParagraphStyleAttributeName: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .Center
                }
                ]).drawInRect(CGRectMake(0,-5,45,29))
            }.imageWithRenderingMode(.AlwaysOriginal)
        self.stepper.setIncrementImage(imright, forState:.Normal)
        
        let imrightblack = imageOfSize(CGSizeMake(45,29)) {
            NSAttributedString(string:"\u{21DB}", attributes:[
                NSFontAttributeName: UIFont(name:"GillSans-Bold", size:30)!,
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSParagraphStyleAttributeName: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .Center
                }
                ]).drawInRect(CGRectMake(0,-5,45,29))
            }.imageWithRenderingMode(.AlwaysOriginal)
        self.stepper.setIncrementImage(imrightblack, forState:.Disabled)
        
        let imrighttint = imageOfSize(CGSizeMake(45,29)) {
            NSAttributedString(string:"\u{21DB}", attributes:[
                NSFontAttributeName: UIFont(name:"GillSans-Bold", size:30)!,
                NSForegroundColorAttributeName: self.stepper.tintColor,
                NSParagraphStyleAttributeName: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .Center
                }
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
