
import UIKit

func imageOfSize(_ size:CGSize, closure:() -> ()) -> UIImage {
    let r = UIGraphicsImageRenderer(size:size)
    return r.image {
        _ in closure()
    }
}

func lend<T> (closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

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



class ViewController: UIViewController {
    
    @IBOutlet var stepper : UIStepper!
    @IBOutlet var prog : UIProgressView!
    
    @IBAction func doStep(_ sender: Any!) {
        let step = sender as! UIStepper
        self.prog.setProgress(Float(step.value / (step.maximumValue - step.minimumValue)), animated:true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // return;
        
        self.stepper.tintColor = UIColor.yellow
        
        let imdis = UIImage(named: "pic2.png")!
            .resizableImage(withCapInsets:
                UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode:.stretch)
        self.stepper.setBackgroundImage(imdis, for:.disabled)
        
        let imnorm = UIImage(named: "pic1.png")!
            .resizableImage(withCapInsets:
                UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode:.stretch)
        self.stepper.setBackgroundImage(imnorm, for:.normal)
        
        let tint = imageOfSize(CGSize(3,3)) {
            self.stepper.tintColor.setFill()
            UIGraphicsGetCurrentContext()!.fill(CGRect(0,0,3,3))
        }.resizableImage(withCapInsets:
            UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode:.stretch)
        self.stepper.setDividerImage(tint, forLeftSegmentState:.normal, rightSegmentState:.normal)
        self.stepper.setDividerImage(tint, forLeftSegmentState:.highlighted, rightSegmentState:.normal)
        self.stepper.setDividerImage(tint, forLeftSegmentState:.normal, rightSegmentState:.highlighted)

        // image (treated as template by default)
        
        let imleft = imageOfSize(CGSize(45,29)) {
            NSAttributedString(string:"\u{21DA}", attributes:[
                .font: UIFont(name:"GillSans-Bold", size:30)!,
                .foregroundColor: UIColor.white,
                .paragraphStyle: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .center
                    }
                ]).draw(in:CGRect(0,-5,45,29))
        }.withRenderingMode(.alwaysOriginal)
        self.stepper.setDecrementImage(imleft, for:.normal)
        
        let imleftblack = imageOfSize(CGSize(45,29)) {
            NSAttributedString(string:"\u{21DA}", attributes:[
                .font: UIFont(name:"GillSans-Bold", size:30)!,
                .foregroundColor: UIColor.black,
                .paragraphStyle: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .center
                }
                ]).draw(in:CGRect(0,-5,45,29))
            }.withRenderingMode(.alwaysOriginal)
        self.stepper.setDecrementImage(imleftblack, for:.disabled)

        let imlefttint = imageOfSize(CGSize(45,29)) {
            NSAttributedString(string:"\u{21DA}", attributes:[
                .font: UIFont(name:"GillSans-Bold", size:30)!,
                .foregroundColor: self.stepper.tintColor,
                .paragraphStyle: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .center
                }
                ]).draw(in:CGRect(0,-5,45,29))
            }.withRenderingMode(.alwaysOriginal)
        self.stepper.setDecrementImage(imlefttint, for:.highlighted)

        let imright = imageOfSize(CGSize(45,29)) {
            NSAttributedString(string:"\u{21DB}", attributes:[
                .font: UIFont(name:"GillSans-Bold", size:30)!,
                .foregroundColor: UIColor.white,
                .paragraphStyle: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .center
                }
                ]).draw(in:CGRect(0,-5,45,29))
            }.withRenderingMode(.alwaysOriginal)
        self.stepper.setIncrementImage(imright, for:.normal)
        
        let imrightblack = imageOfSize(CGSize(45,29)) {
            NSAttributedString(string:"\u{21DB}", attributes:[
                .font: UIFont(name:"GillSans-Bold", size:30)!,
                .foregroundColor: UIColor.black,
                .paragraphStyle: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .center
                }
                ]).draw(in:CGRect(0,-5,45,29))
            }.withRenderingMode(.alwaysOriginal)
        self.stepper.setIncrementImage(imrightblack, for:.disabled)
        
        let imrighttint = imageOfSize(CGSize(45,29)) {
            NSAttributedString(string:"\u{21DB}", attributes:[
                .font: UIFont(name:"GillSans-Bold", size:30)!,
                .foregroundColor: self.stepper.tintColor,
                .paragraphStyle: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .center
                }
                ]).draw(in:CGRect(0,-5,45,29))
            }.withRenderingMode(.alwaysOriginal)
        self.stepper.setIncrementImage(imrighttint, for:.highlighted)

        return; // interesting effect: remove overlay entirely if disabled
        
        let emptyim = imageOfSize(CGSize(45,29)) {}
        
//        UIGraphicsBeginImageContextWithOptions(CGSize(45,29), false, 0)
//        let emptyim = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext();
        self.stepper.setDecrementImage(emptyim, for:.disabled)
        self.stepper.setIncrementImage(emptyim, for:.disabled)
        
    }


}
